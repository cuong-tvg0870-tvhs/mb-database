-- Thêm cột "businessName" (tên BM sở hữu tài sản) cho phiếu đề xuất cấp quyền.
-- Requester khai kèm Business Manager ID để admin nhận diện nhanh BM chủ sở hữu.
-- Additive, non-breaking: cột nullable, hàng cũ không cần backfill và hai writer
-- (mb-ads/mb-batch) đang chạy không vỡ. KHÔNG dùng `prisma migrate dev` ở repo này
-- (DATABASE_URL trỏ prod qua tunnel) — apply bằng `prisma migrate deploy`.
ALTER TABLE "AssetAccessRequest" ADD COLUMN "businessName" TEXT;
