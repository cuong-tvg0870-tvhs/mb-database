-- Mục đích: cho phép "BƠM THÊM" adset/ad MỚI vào 1 campaign ĐANG CHẠY trên Meta mà
-- KHÔNG đụng / không sửa / không xoá bất cứ thứ gì đã live (đặc biệt các nhóm đang chạy
-- tốt). Áp dụng cho CẢ campaign do hệ thống tạo LẪN campaign tạo tay trực tiếp trên Ads
-- Manager (external). Mỗi lần bơm = 1 "vỏ bơm-thêm" (append-shell) SystemCampaign riêng.
--
-- Thêm 2 cột vào SystemCampaign:
--   * appendOnly (BOOLEAN, default false): đánh dấu bản ghi là VỎ bơm-thêm. Khi
--       appendOnly=true, publisher (mb-ads pushToMetaCore) BỎ HẲN upsertCampaignToMeta
--       (không bao giờ sửa campaign live), chỉ CREATE các con meta_id=NULL dưới
--       appendTargetCampaignId; con đã có meta_id thì SKIP hoàn toàn (không diff/không
--       update). Vỏ cũng bị loại khỏi danh sách nháp (list) và khỏi bộ chọn của
--       automation scheduler mb-batch.
--   * appendTargetCampaignId (TEXT, nullable): id campaign Meta live cần bơm vào. Là
--       STRING LỎNG, CỐ Ý KHÔNG đặt FK tới Campaign (theo đúng convention lỏng của
--       accountId/createdById) để KHÔNG tạo thêm cạnh onDelete: Cascade nào — nếu FK +
--       cascade, xoá vỏ có thể kéo xoá campaign mirror live. Có index để tra nhanh các
--       vỏ theo campaign đích.
--
-- Bất biến an toàn: meta_id của VỎ LUÔN giữ NULL. Nhờ vậy (1) né được @unique trên
-- SystemCampaign.meta_id kể cả khi campaign hệ-thống-tạo đã sở hữu meta_id đó; (2)
-- bước sync-back sau publish không gắn systemCampaignId của vỏ lên Campaign live (append
-- mode truyền systemCampaignId=undefined) → không cướp provenance nháp gốc, không kích
-- hoạt cascade-delete. Nhiều vỏ cùng trỏ 1 appendTargetCampaignId là hợp lệ (đều meta_id
-- NULL nên không đụng @unique).
--
-- An toàn dữ liệu: appendOnly có default hằng false → Postgres thêm cột dạng metadata,
-- KHÔNG rewrite bảng (online-safe trên bảng lớn); appendTargetCampaignId nullable không
-- backfill. Mọi campaign/nháp/mẫu CŨ mặc định appendOnly=false → additive thuần, không
-- đổi luồng publish hiện tại.
--
-- Rollout: apply lúc nào cũng được, không cần dừng writer (mb-ads/mb-batch). Không backfill.

-- AlterTable
ALTER TABLE "SystemCampaign" ADD COLUMN     "appendOnly" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "appendTargetCampaignId" TEXT;

-- CreateIndex
CREATE INDEX "SystemCampaign_appendTargetCampaignId_idx" ON "SystemCampaign"("appendTargetCampaignId");
