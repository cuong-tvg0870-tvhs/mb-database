-- "Ai sửa gần nhất" cho 3 model automation (AutomationCategory / AutomationFolder /
-- AutomationRule) — phục vụ tính năng "update by id cho category/rule".
--
-- Scalar-only (KHÔNG @relation sang User) — giữ đúng quy ước của "createdById" ở cả 3
-- bảng: tên người sửa được resolve bằng truy vấn phụ, không FK. Vì vậy chỉ cần cột TEXT
-- nullable, không constraint.
--
-- Backfill = "createdById": row cũ coi như "người tạo cũng là người sửa gần nhất" nên
-- "updatedById" không NULL nếu "createdById" khác NULL (NULL vẫn giữ NULL). 3 bảng này là
-- config nhỏ (Category/Folder/Rule) — UPDATE toàn bảng an toàn, KHÔNG phải bảng nóng
-- AutomationRuleRunItem.
--
-- Additive, không đổi/xoá cột → an toàn rolling deploy (mb-ads/mb-batch cũ chưa đọc cột
-- mới vẫn chạy bình thường; áp migration TRƯỚC khi deploy code mới).

ALTER TABLE "AutomationCategory" ADD COLUMN "updatedById" TEXT;
ALTER TABLE "AutomationFolder"   ADD COLUMN "updatedById" TEXT;
ALTER TABLE "AutomationRule"     ADD COLUMN "updatedById" TEXT;

UPDATE "AutomationCategory" SET "updatedById" = "createdById" WHERE "createdById" IS NOT NULL;
UPDATE "AutomationFolder"   SET "updatedById" = "createdById" WHERE "createdById" IS NOT NULL;
UPDATE "AutomationRule"     SET "updatedById" = "createdById" WHERE "createdById" IS NOT NULL;
