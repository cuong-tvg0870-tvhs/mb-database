-- Trạng thái nhân bản AutomationCategory chạy nền.
-- Additive/non-breaking: các category cũ giữ cloneStatus = NULL,
-- nghĩa là category thường, nên không cần backfill.

CREATE TYPE "AutomationCategoryCloneStatus"
AS ENUM ('PENDING', 'RUNNING', 'DONE', 'FAILED');

ALTER TABLE "AutomationCategory"
  ADD COLUMN "cloneError" TEXT,
  ADD COLUMN "cloneSourceId" TEXT,
  ADD COLUMN "cloneStatus" "AutomationCategoryCloneStatus";