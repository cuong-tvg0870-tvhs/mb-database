-- Thêm trạng thái SKIPPED_STALE cho AutomationRuleRunStatus.
-- Job nằm trong hàng đợi quá lâu (backlog) mới tới worker, đã trễ so với
-- `scheduledFor`; đánh giá tiếp sẽ tốn Meta call để hành động trên ý định cũ,
-- nên bỏ qua — hiển thị rõ ràng, không âm thầm.
-- Additive/non-breaking: chỉ bổ sung value vào enum, run cũ không đổi.

ALTER TYPE "AutomationRuleRunStatus" ADD VALUE 'SKIPPED_STALE';
