-- Idempotency guard for automation runs.
-- `dedupeKey` is NULL on legacy + SKIPPED_OVERLAP rows; Postgres treats NULLs as
-- distinct, so the unique index only enforces one real run per (rule, account,
-- aligned-window). Existing duplicate history is therefore left untouched.
-- IF NOT EXISTS keeps this safe to re-apply on top of a drifted database.

-- AlterTable
ALTER TABLE "AutomationRuleRun" ADD COLUMN IF NOT EXISTS "dedupeKey" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AutomationRuleRun_dedupeKey_key" ON "AutomationRuleRun"("dedupeKey");
