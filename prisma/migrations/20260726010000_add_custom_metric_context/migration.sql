-- Migration: CUSTOM METRIC — thêm cột NGỮ CẢNH (context).
--
-- Bối cảnh: bổ sung custom metric cho hệ rule của MB (Phase 1: "Mẫu lịch chạy" /
-- tăng ngân sách theo lịch, chạy ở mb-batch, đọc Meta LIVE cấp campaign/adset).
-- Custom metric của mỗi ngữ cảnh dùng nguồn dữ liệu + vocab base metric KHÁC nhau
-- (budget-schedule = key snake Meta live; auto-launch = CreativeInsight; dashboard =
-- cột list). Dùng chéo sẽ ra SỐ SAI. Cột `context` để mỗi consumer chỉ nạp metric
-- đúng ngữ cảnh của mình (runner budget-schedule chỉ nạp context='BUDGET_SCHEDULE';
-- picker dashboard/care-ads lọc context IS NULL).
--
-- An toàn: thuần ADDITIVE. CREATE TYPE (không đụng bảng) + ADD COLUMN nullable, KHÔNG
-- default, KHÔNG backfill → metadata-only, tức thì, không rewrite bảng, không khoá lâu.
-- Mọi row cũ (care-ads GLOBAL/AD_ACCOUNT/CATEGORY, dashboard USER) giữ context = NULL.
-- Cả 3 writer hiện hữu (mb-ads dashboard, care-ads-backend) không set cột này → Prisma
-- bỏ qua, chạy nguyên trạng. Back-compat với DB shared 2-writer. Rollout lúc nào cũng được.

CREATE TYPE "CustomMetricContext" AS ENUM ('BUDGET_SCHEDULE', 'AUTO_LAUNCH', 'DASHBOARD');

ALTER TABLE "custom_metrics" ADD COLUMN "context" "CustomMetricContext";

CREATE INDEX "custom_metrics_context_idx" ON "custom_metrics"("context");
