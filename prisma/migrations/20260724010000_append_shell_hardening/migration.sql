-- Mục đích: gia cố an toàn cho luồng "Bơm thêm nhóm/quảng cáo vào campaign đang chạy"
-- (append-shell). Vá 3 rủi ro: (1) xoá vỏ kéo cascade xoá campaign live; (2) tạo TRÙNG
-- adset/ad khi Meta tạo xong nhưng ghi DB lỗi; (3) mất khả năng reconcile an toàn.
--
-- Thay đổi:
--   1. Campaign.systemCampaignId FK: ON DELETE CASCADE → SET NULL. Nháp/vỏ SystemCampaign
--      KHÔNG phải "chủ" của campaign live — xoá nháp KHÔNG được kéo xoá Campaign mirror +
--      AdSet/Ad/insight cascade. Mất link chỉ set null; meta-sync tự gắn lại theo meta_id.
--      (Kết hợp fix HOLE 1: sync-back append truyền systemCampaignId=undefined → live
--      Campaign KHÔNG BAO GIỜ trỏ về vỏ; đây là phòng thủ chiều sâu cho mọi trường hợp.)
--   2. SystemCampaign.appendPreexisting (JSONB): snapshot { adSetIds, adIds } đã có trên
--      campaign đích TRƯỚC khi bơm (chụp ở preflight publish lần đầu). Reconcile-by-name
--      chỉ xét entity live KHÔNG nằm trong snapshot → tránh nhận nhầm nhóm cũ trùng tên
--      rồi bơm ad vào nhóm đang chạy tốt.
--   3. SystemAdSet.metaCreateState / SystemAd.metaCreateState (TEXT): ledger idempotency.
--      'CREATING' đặt NGAY TRƯỚC Meta create, clear sau khi ghi meta_id. Kẹt 'CREATING'
--      + meta_id=null = Meta có thể đã tạo mà DB chưa ghi → lần sau reconcile trước khi
--      tạo lại. 'UNCERTAIN' = mơ hồ (nhiều ứng viên) → BỎ QUA, không tạo trùng, báo user.
--
-- An toàn: 3 cột mới đều NULLABLE, không default, không backfill (mọi row cũ = null =
-- hành vi cũ). Đổi FK là thao tác metadata (drop+add constraint) — nhanh, không rewrite
-- bảng, nhưng cần khoá ngắn ACCESS EXCLUSIVE trên "Campaign" (chấp nhận được). PublishHistory
-- CỐ Ý KHÔNG đổi sang Restrict (sẽ vỡ deleteDraft nháp-đã-thử-publish + cron cleanup
-- mb-batch dựa vào cascade); bảo vệ audit của vỏ bằng SOFT-DELETE ở tầng ứng dụng.
--
-- Rollout: additive + đổi FK; apply lúc nào cũng được, không cần dừng writer.

-- 1) Campaign.systemCampaignId FK → ON DELETE SET NULL
ALTER TABLE "Campaign" DROP CONSTRAINT "Campaign_systemCampaignId_fkey";
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_systemCampaignId_fkey" FOREIGN KEY ("systemCampaignId") REFERENCES "SystemCampaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- 2) Snapshot pre-existing để reconcile an toàn
ALTER TABLE "SystemCampaign" ADD COLUMN     "appendPreexisting" JSONB;

-- 3) Ledger idempotency markers (String tự do 'CREATING'/'UNCERTAIN'/null)
ALTER TABLE "SystemAdSet" ADD COLUMN     "metaCreateState" TEXT;
ALTER TABLE "SystemAd" ADD COLUMN     "metaCreateState" TEXT;
