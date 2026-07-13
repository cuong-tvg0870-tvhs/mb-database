-- Bộ lọc mặc định của user trên các màn list.
-- Thêm cột "isDefault" vào SavedFilter: đánh dấu bộ lọc user muốn tự áp khi mở màn.
-- Additive, NOT NULL DEFAULT false → các dòng cũ = false, không đổi hành vi cũ.
-- Ràng buộc "chỉ 1 default / (userId, tableKey)" enforce ở tầng app (service clearDefault),
-- không dùng partial unique index để tránh khoá cứng dữ liệu cũ. Chưa apply prod tự động.

-- AlterTable
ALTER TABLE "SavedFilter" ADD COLUMN "isDefault" BOOLEAN NOT NULL DEFAULT false;
