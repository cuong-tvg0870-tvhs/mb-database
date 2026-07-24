-- Retry/checkpoint metadata cho các run DEFERRED + 2 index/unique đi kèm.
-- Additive/non-breaking: mọi cột đều nullable hoặc có DEFAULT, run cũ giữ nguyên.
--
-- AutomationRuleRun — thêm 5 cột (thông tin cho UI + vận hành cho runner khi
-- resume trong cùng slot):
--   * deferReason   (TEXT, nullable): lý do hoãn (mã lỗi Meta / throttle / pacing).
--   * deferAttempt  (INT, default 0): số lần đã hoãn-rồi-thử-lại của run này.
--   * nextRetryAt   (TIMESTAMP, nullable): mốc dự kiến retry kế tiếp.
--   * resumePhase   (TEXT, nullable): pha runner cần tiếp tục từ đó khi resume.
--   * checkpointKey (TEXT, nullable): khoá checkpoint để resume idempotent.
--
-- Index mới AutomationRuleRun(ruleId, accountId, status): tra nhanh run đang
-- DEFERRED/RUNNING theo rule+account cho vòng resume của runner.
--
-- Unique mới AutomationRuleRunItem(runId, taskId, entityId): chặn ghi trùng item
-- khi 1 run được retry nhiều lần trong cùng slot — mỗi (run, task, entity) đúng 1
-- row, retry chỉ upsert lại chứ không đẻ thêm.

-- AlterTable
ALTER TABLE "AutomationRuleRun" ADD COLUMN     "deferReason" TEXT,
ADD COLUMN     "deferAttempt" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "nextRetryAt" TIMESTAMP(3),
ADD COLUMN     "resumePhase" TEXT,
ADD COLUMN     "checkpointKey" TEXT;

-- CreateIndex
CREATE INDEX "AutomationRuleRun_ruleId_accountId_status_idx" ON "AutomationRuleRun"("ruleId", "accountId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "AutomationRuleRunItem_runId_taskId_entityId_key" ON "AutomationRuleRunItem"("runId", "taskId", "entityId");
