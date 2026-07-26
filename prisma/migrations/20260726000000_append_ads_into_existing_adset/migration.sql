-- Migration: BƠM QUẢNG CÁO VÀO NHÓM (ad set) ĐANG CHẠY.
--
-- Bối cảnh: luồng "Bơm thêm" trước đây chỉ tạo được NHÓM QC mới. Tính năng này cho phép
-- bơm quảng cáo MỚI vào một nhóm ĐÃ CÓ / đang chạy trên Meta. Node "ad set đích" trong vỏ
-- bơm-thêm mang id ad set live ở cột dưới đây; publisher dùng nó làm cha để CREATE ad con,
-- TUYỆT ĐỐI không gọi upsertAdSetToMeta (không đụng nhóm đang chạy). meta_id của node đích
-- giữ NULL; node đích bị loại khỏi empty-guard "nhóm mới".
--
-- An toàn: chỉ ADD COLUMN nullable → metadata-only, tức thì, KHÔNG rewrite bảng, KHÔNG khoá
-- lâu, KHÔNG backfill. Writer cũ (mb-ads/mb-batch bản trước) không đụng cột → back-compat.
-- Rollout lúc nào cũng được.

ALTER TABLE "SystemAdSet" ADD COLUMN     "appendTargetAdSetId" TEXT;
