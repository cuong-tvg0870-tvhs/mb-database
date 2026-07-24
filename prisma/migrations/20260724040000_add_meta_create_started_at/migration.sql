-- Migration BÙ: thêm cột metaCreateStartedAt (mốc BẮT ĐẦU gọi Meta create entity — cửa sổ
-- reconcile CHẶT per-entity cho luồng "Bơm thêm", xem SystemAdSet.metaCreateStartedAt).
--
-- Bối cảnh: cột này đáng lẽ thuộc `20260724010000_append_shell_hardening`, nhưng bản
-- migration đó ĐÃ được deploy prod (bản cũ chưa có cột này) trước khi cột được bổ sung vào
-- schema → Prisma coi 010000 "đã áp" nên không chạy lại. Vì vậy tách thành migration RIÊNG.
--
-- An toàn: chỉ ADD COLUMN nullable → metadata-only, tức thì, KHÔNG rewrite bảng, KHÔNG khoá
-- lâu. Không backfill. Rollout lúc nào cũng được.

ALTER TABLE "SystemAdSet" ADD COLUMN     "metaCreateStartedAt" TIMESTAMP(3);
ALTER TABLE "SystemAd" ADD COLUMN     "metaCreateStartedAt" TIMESTAMP(3);
