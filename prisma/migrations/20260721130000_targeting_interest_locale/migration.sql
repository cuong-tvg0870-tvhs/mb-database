-- Mục đích: cho phép cache targeting (TargetingInterest) lưu NHIỀU BẢN LOCALE
-- của cùng một entity Meta, để search sở thích chạy theo thị trường của TKQC
-- (vd TKQC Việt Nam search ra tên tiếng Việt, TKQC Thái ra tên tiếng Thái).
--
-- Vì sao cần: trước đây khoá chính `id` = Meta id, mỗi entity chỉ có ĐÚNG 1 hàng.
-- Nếu bật `locale` cho lời gọi Meta mà không tách hàng, read-through cache
-- (meta.service.ts searchTargetingLive) sẽ upsert đè lẫn nhau — tên tiếng Việt
-- và tiếng Thái ghi đè qua lại, hỏng âm thầm không báo lỗi.
--
-- Back-compat (QUAN TRỌNG):
--   * `id` GIỮ NGUYÊN ngữ nghĩa cho locale mặc định en_US: id == Meta id.
--     Đường đọc local hiện tại (dropdown.service.ts trả thẳng row ra FE, FE lấy
--     `id` bỏ vào flexible_spec.interests khi publish) vẫn đúng với dữ liệu cũ.
--   * Hàng locale khác dùng khoá tổng hợp "<metaId>__<locale>"; app PHẢI đọc
--     `metaId` để lấy id thật gửi Meta. App đã được sửa kèm theo migration này.
--   * Toàn bộ thay đổi là ADDITIVE: chỉ thêm cột nullable / có DEFAULT + index.
--     Writer cũ (bản chưa deploy) vẫn ghi được, hàng sinh ra mặc định en_US.
--
-- Rollout: apply migration TRƯỚC khi deploy mb-ads. Không có bước phá huỷ.

-- AlterTable
ALTER TABLE "TargetingInterest" ADD COLUMN     "locale" TEXT NOT NULL DEFAULT 'en_US',
ADD COLUMN     "metaId" TEXT;

-- Backfill: toàn bộ hàng cũ là dữ liệu locale mặc định, và `id` của chúng chính
-- là Meta id. Chạy TRƯỚC khi tạo unique index để index dựng được ngay lần đầu.
UPDATE "TargetingInterest" SET "metaId" = "id" WHERE "metaId" IS NULL;

-- CreateIndex
CREATE INDEX "TargetingInterest_type_locale_idx" ON "TargetingInterest"("type", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "TargetingInterest_metaId_locale_key" ON "TargetingInterest"("metaId", "locale");
