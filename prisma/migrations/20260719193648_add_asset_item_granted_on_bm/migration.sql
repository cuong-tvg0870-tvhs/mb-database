-- Cột "người xử lý ở BM đã tích đã phân quyền trên BM" cho từng tài sản.
-- Additive: cột nullable + default false → an toàn, KHÔNG phá writer đang chạy,
-- không sửa/xoá dữ liệu cũ. Đây là migration pending DUY NHẤT (mọi migration
-- trước đã apply prod & khớp) nên `yarn migration:run` chỉ áp đúng cột này.
ALTER TABLE "AssetAccessRequestItem"
  ADD COLUMN "grantedOnBm" BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN "grantedOnBmAt" TIMESTAMP(3),
  ADD COLUMN "grantedOnBmById" TEXT,
  ADD COLUMN "grantedOnBmByName" TEXT;
