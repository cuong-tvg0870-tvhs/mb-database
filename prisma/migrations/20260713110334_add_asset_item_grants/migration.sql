-- Thêm cột `grants` (JSONB) cho AssetAccessRequestItem.
-- Mỗi tài sản trong phiếu lưu danh sách người được cấp quyền + mức quyền riêng:
--   [{ "userId": "...", "name": "...", "permission": "EDITOR|EDIT|VIEW|ADMIN|VIEWER" }]
-- Khi admin confirm: tài sản vào dự án + từng user được cấp đúng mức ngay.
-- ADDITIVE, nullable — an toàn, không phá dữ liệu cũ (bảng đang rỗng ở prod).
ALTER TABLE "AssetAccessRequestItem" ADD COLUMN "grants" JSONB;
