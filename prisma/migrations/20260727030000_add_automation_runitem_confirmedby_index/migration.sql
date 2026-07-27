-- Index per-user "số lần xác nhận" trên bảng NÓNG "AutomationRuleRunItem" (~6.25M dòng).
-- Phục vụ dashboard "Giám sát sử dụng" (GET /dashboard/usage): groupBy confirmedById
-- trước đây SEQ SCAN toàn bảng mỗi lần load. Tên index khớp mặc định Prisma
-- ("AutomationRuleRunItem_confirmedById_idx") nên `prisma migrate` coi như đã thoả @@index.
--
-- ⚠️ PROD — KHÔNG apply file này thẳng qua `prisma migrate deploy` trên bảng nóng:
--   CREATE INDEX (không CONCURRENTLY) KHOÁ GHI cả bảng 6.25M dòng → chặn writer automation.
--   Quy trình prod (chạy TAY, NGOÀI transaction):
--     CREATE INDEX CONCURRENTLY IF NOT EXISTS "AutomationRuleRunItem_confirmedById_idx"
--       ON "AutomationRuleRunItem" ("confirmedById");
--   rồi đánh dấu đã áp:
--     prisma migrate resolve --applied 20260727030000_add_automation_runitem_confirmedby_index
--
-- Câu lệnh dưới (IF NOT EXISTS, KHÔNG CONCURRENTLY) an toàn cho DB mới/rỗng và là NO-OP
-- nếu index đã tồn tại (đã tạo tay ở prod) — giữ lịch sử migration nhất quán.
CREATE INDEX IF NOT EXISTS "AutomationRuleRunItem_confirmedById_idx"
  ON "AutomationRuleRunItem" ("confirmedById");
