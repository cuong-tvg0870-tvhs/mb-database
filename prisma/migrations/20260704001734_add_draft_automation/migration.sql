-- CreateEnum
CREATE TYPE "DraftAutomationSourceType" AS ENUM ('TEMPLATE', 'QUICK_CONFIG');

-- CreateEnum
CREATE TYPE "DraftAutomationScheduleType" AS ENUM ('INTERVAL', 'CRON');

-- CreateEnum
CREATE TYPE "DraftAutomationRunMode" AS ENUM ('LOOP', 'ONCE');

-- CreateEnum
CREATE TYPE "DraftAutomationStatus" AS ENUM ('ACTIVE', 'PAUSED', 'COMPLETED');

-- AlterTable
ALTER TABLE "DraftAutomationHistory" ADD COLUMN     "draftAutomationId" TEXT;

-- CreateTable
CREATE TABLE "DraftAutomation" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "sourceType" "DraftAutomationSourceType" NOT NULL DEFAULT 'TEMPLATE',
    "templateId" TEXT,
    "quickConfig" JSONB,
    "folderId" TEXT,
    "conditions" JSONB,
    "scheduleType" "DraftAutomationScheduleType" NOT NULL DEFAULT 'INTERVAL',
    "intervalMinutes" INTEGER,
    "cronExpression" TEXT,
    "timezone" TEXT,
    "runMode" "DraftAutomationRunMode" NOT NULL DEFAULT 'LOOP',
    "publishMode" "DraftAutomationPublishMode" NOT NULL DEFAULT 'DRAFT_ONLY',
    "status" "DraftAutomationStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastRunAt" TIMESTAMP(3),
    "nextRunAt" TIMESTAMP(3),
    "lastRunStatus" "DraftAutomationRunStatus",
    "lastRunReason" TEXT,
    "runCount" INTEGER NOT NULL DEFAULT 0,
    "accountId" TEXT,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DraftAutomation_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DraftAutomation_status_nextRunAt_idx" ON "DraftAutomation"("status", "nextRunAt");

-- CreateIndex
CREATE INDEX "DraftAutomation_templateId_createdAt_idx" ON "DraftAutomation"("templateId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DraftAutomation_accountId_createdAt_idx" ON "DraftAutomation"("accountId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DraftAutomation_createdById_createdAt_idx" ON "DraftAutomation"("createdById", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DraftAutomationHistory_draftAutomationId_createdAt_idx" ON "DraftAutomationHistory"("draftAutomationId", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "DraftAutomationHistory" ADD CONSTRAINT "DraftAutomationHistory_draftAutomationId_fkey" FOREIGN KEY ("draftAutomationId") REFERENCES "DraftAutomation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DraftAutomation" ADD CONSTRAINT "DraftAutomation_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "TemplateCampaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;
