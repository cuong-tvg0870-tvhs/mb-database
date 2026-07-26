-- Migration: index cho job re-host ảnh (module creative-media ở mb-batch).
--
-- Bối cảnh: 3 cột owned* đã áp ở 20260726020000. Job re-host quét
--   WHERE "ownedImageUrl" IS NULL ORDER BY "updatedAt" DESC   mỗi giờ.
-- Tách index ra migration RIÊNG vì migration cột kia đã apply prod (không sửa lại được nữa
-- kẻo lệch checksum).
--
-- An toàn: CREATE INDEX thường (không CONCURRENTLY — Prisma chạy migration trong transaction).
-- Creative ~45k dòng → khoá viết chỉ ~mili-giây, additive, rollout lúc nào cũng được.

CREATE INDEX "Creative_ownedImageUrl_updatedAt_idx" ON "Creative"("ownedImageUrl", "updatedAt" DESC);
