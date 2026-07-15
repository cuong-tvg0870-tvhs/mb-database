-- Thêm cột cờ "đã chia sẻ tài sản về BM công ty (BM02)" cho phiếu đề xuất cấp quyền.
-- Additive, non-breaking: có DEFAULT false nên hàng cũ không cần backfill và hai
-- writer (mb-ads/mb-batch) đang chạy không vỡ. KHÔNG được dùng `prisma migrate dev`
-- ở repo này (DATABASE_URL trỏ prod qua tunnel) — apply bằng `prisma migrate deploy`.
ALTER TABLE "AssetAccessRequest" ADD COLUMN "sharedToBm" BOOLEAN NOT NULL DEFAULT false;
