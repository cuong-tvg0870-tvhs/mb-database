-- Chống publish trùng campaign lên Meta (race re-publish + khóa kẹt mb-batch).
--
-- 1) publishClaimedAt: mốc thời điểm chiếm cờ isPublishing. mb-ads dùng để KHÔNG
--    gỡ nhầm cờ của tiến trình vừa claim nhưng chưa kịp tạo PublishHistory (cửa
--    sổ race khi re-publish); mb-batch dùng để tự gỡ khóa kẹt sau 20 phút (pod
--    crash sau khi claim). Nullable -> additive & non-breaking.
ALTER TABLE "SystemCampaign" ADD COLUMN "publishClaimedAt" TIMESTAMP(3);

-- 2) Unique index trên meta_id: lưới an toàn tầng DB — không cho 2 bản ghi
--    SystemCampaign cùng trỏ về 1 campaign Meta. Postgres mặc định NULLS DISTINCT
--    nên hàng ngàn draft meta_id NULL không bị ảnh hưởng.
--    TRƯỚC KHI DEPLOY: xác nhận không có dữ liệu trùng sẵn (nếu có, migration fail):
--      SELECT meta_id, COUNT(*) FROM "SystemCampaign"
--      WHERE meta_id IS NOT NULL GROUP BY meta_id HAVING COUNT(*) > 1;
CREATE UNIQUE INDEX "SystemCampaign_meta_id_key" ON "SystemCampaign"("meta_id");
