-- THỨ TỰ TẤT ĐỊNH cho nhóm/quảng cáo trong bản nháp (SystemAdSet.position, SystemAd.position)
--
-- VẤN ĐỀ: draft builder đọc nháp bằng `orderBy: { createdAt: 'asc' }`. Cột createdAt mặc định
-- DEFAULT CURRENT_TIMESTAMP, mà trong Postgres CURRENT_TIMESTAMP CỐ ĐỊNH theo TRANSACTION →
-- mọi nhóm/QC được tạo trong CÙNG một lần Lưu (hàm update() bọc $transaction) nhận createdAt
-- Y HỆT NHAU. ORDER BY khi đó hoà hoàn toàn, không có tiebreak, nên thứ tự trả về phụ thuộc
-- thứ tự vật lý của heap — và thứ tự đó ĐỔI sau mỗi UPDATE (MVCC ghi tuple mới ở cuối heap).
-- Frontend lại gán id server vào từng card THEO INDEX mảng (use-draft-campaign.ts) → id bị dán
-- lệch card → lỗi Meta trả về gắn sai quảng cáo, và nguy hiểm hơn là meta_id gắn sai (lần
-- publish sau đi vào nhánh update và sửa đè lên quảng cáo LIVE khác).
--
-- BACK-COMPAT: additive hoàn toàn, NOT NULL DEFAULT 0 → writer đang chạy (mb-ads, mb-batch)
-- không biết cột này vẫn INSERT/UPDATE bình thường, hàng mới nhận 0. Bản đọc cũ (chỉ order theo
-- createdAt) không bị ảnh hưởng. Thứ tự mới là [position ASC, createdAt ASC, id ASC] nên hàng
-- position=0 vẫn giữ đúng hành vi cũ.
--
-- ROLLOUT: áp SQL này lên prod TRƯỚC khi deploy mb-ads/mb-batch (code mới đọc/ghi position).
-- Không cần downtime; ALTER ... ADD COLUMN với DEFAULT hằng số là metadata-only từ PG 11.

ALTER TABLE "SystemAdSet" ADD COLUMN IF NOT EXISTS "position" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "SystemAd" ADD COLUMN IF NOT EXISTS "position" INTEGER NOT NULL DEFAULT 0;

-- BACKFILL: chốt thứ tự hiện có thành position theo (createdAt, id). LƯU Ý: với các hàng có
-- createdAt HOÀ nhau (cùng 1 transaction Lưu — trên prod là 455 nhóm, ~2215 quảng cáo), thứ tự
-- đang hiển thị hôm nay là thứ tự vật lý heap KHÔNG xác định, nên backfill có thể làm thứ tự
-- card trong một số nhóm NHẢY MỘT LẦN sang thứ tự (createdAt, id) rồi ổn định vĩnh viễn.
-- Vô hại: nội dung đi kèm từng hàng, chỉ là vị trí hiển thị. Idempotent (chạy lại kết quả y hệt).
UPDATE "SystemAdSet" AS s
SET "position" = r.rn - 1
FROM (
  SELECT "id",
         ROW_NUMBER() OVER (PARTITION BY "campaignId" ORDER BY "createdAt" ASC, "id" ASC) AS rn
  FROM "SystemAdSet"
) AS r
WHERE s."id" = r."id" AND s."position" <> r.rn - 1;

UPDATE "SystemAd" AS a
SET "position" = r.rn - 1
FROM (
  SELECT "id",
         ROW_NUMBER() OVER (PARTITION BY "adSetId" ORDER BY "createdAt" ASC, "id" ASC) AS rn
  FROM "SystemAd"
) AS r
WHERE a."id" = r."id" AND a."position" <> r.rn - 1;

CREATE INDEX IF NOT EXISTS "SystemAdSet_campaignId_position_idx" ON "SystemAdSet"("campaignId", "position");
CREATE INDEX IF NOT EXISTS "SystemAd_adSetId_position_idx" ON "SystemAd"("adSetId", "position");
