-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "AutomationInsightBackfillStatus" ADD VALUE 'DEFERRED';
ALTER TYPE "AutomationInsightBackfillStatus" ADD VALUE 'RETRYING';

-- AlterTable
ALTER TABLE "AutomationInsightBackfillState" ADD COLUMN     "lastErrorAt" TIMESTAMP(3),
ADD COLUMN     "lastErrorCode" INTEGER,
ADD COLUMN     "lastErrorContext" JSONB,
ADD COLUMN     "lastErrorFbtrace" TEXT,
ADD COLUMN     "lastErrorHttpStatus" INTEGER,
ADD COLUMN     "lastErrorSubcode" INTEGER,
ADD COLUMN     "nextRetryAt" TIMESTAMP(3),
ADD COLUMN     "phase" TEXT,
ADD COLUMN     "retryCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "waitReason" TEXT;

-- CreateIndex
CREATE INDEX "AutomationInsightBackfillState_nextRetryAt_idx" ON "AutomationInsightBackfillState"("nextRetryAt");
