-- Thêm giá trị enum SKIPPED_SUPERSEDED cho AutomationRuleRunStatus.
-- Ngữ cảnh: một tick MỚI hơn của cùng (rule, account) đã sở hữu cặp này nên
-- slot cũ là dư thừa và được gộp vào tick mới (coalesce). Cũng bao trường hợp
-- "run trước còn giữ run-lock". KHÔNG phải lỗi và KHÔNG phải dữ liệu cũ:
-- run mới tự fetch insight tươi. Ẩn khỏi rule-log của user, chỉ hiện ở Meta Debug.
--
-- Additive & non-breaking: chỉ thêm value vào enum, không đụng row cũ.
-- ADD VALUE không chạy được trong transaction block -> để statement đứng riêng.
-- IF NOT EXISTS để idempotent (an toàn nếu prod đã apply tay trước đó).
ALTER TYPE "AutomationRuleRunStatus" ADD VALUE IF NOT EXISTS 'SKIPPED_SUPERSEDED';
