-- Persistent historical insight cache (giảm tải Meta API).
-- Granularity = apiLevel (adset|ad); rollup lên campaign chạy ở read-time.
-- Idempotent (DO/IF NOT EXISTS) — an toàn re-apply trên DB đã drift.

-- CreateEnum
DO $$ BEGIN
  CREATE TYPE "AutomationInsightApiLevel" AS ENUM ('ADSET', 'AD');
EXCEPTION WHEN duplicate_object THEN null; END $$;

DO $$ BEGIN
  CREATE TYPE "AutomationInsightBackfillStatus" AS ENUM ('PENDING', 'RUNNING', 'COMPLETED', 'FAILED');
EXCEPTION WHEN duplicate_object THEN null; END $$;

-- CreateTable
CREATE TABLE IF NOT EXISTS "AutomationInsightDaily" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "apiLevel" "AutomationInsightApiLevel" NOT NULL,
    "entityId" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "metrics" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "AutomationInsightDaily_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "AutomationInsightBackfillState" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "apiLevel" "AutomationInsightApiLevel" NOT NULL,
    "status" "AutomationInsightBackfillStatus" NOT NULL DEFAULT 'PENDING',
    "targetSinceDate" TEXT NOT NULL,
    "oldestSettledDate" TEXT,
    "lastSettledDate" TEXT,
    "lastRevalidatedAt" TIMESTAMP(3),
    "errorMessage" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "AutomationInsightBackfillState_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "AutomationInsightDeepAggregate" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "apiLevel" "AutomationInsightApiLevel" NOT NULL,
    "entityId" TEXT NOT NULL,
    "throughDate" TEXT NOT NULL,
    "metrics" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "AutomationInsightDeepAggregate_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AutomationInsightDaily_accountId_apiLevel_entityId_date_key" ON "AutomationInsightDaily"("accountId", "apiLevel", "entityId", "date");
CREATE INDEX IF NOT EXISTS "AutomationInsightDaily_accountId_apiLevel_date_idx" ON "AutomationInsightDaily"("accountId", "apiLevel", "date");

CREATE UNIQUE INDEX IF NOT EXISTS "AutomationInsightBackfillState_accountId_apiLevel_key" ON "AutomationInsightBackfillState"("accountId", "apiLevel");

CREATE UNIQUE INDEX IF NOT EXISTS "AutomationInsightDeepAggregate_accountId_apiLevel_entityId_key" ON "AutomationInsightDeepAggregate"("accountId", "apiLevel", "entityId");
