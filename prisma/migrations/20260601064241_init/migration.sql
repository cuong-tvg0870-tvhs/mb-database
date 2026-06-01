-- CreateEnum
CREATE TYPE "DraftAutomationRunStatus" AS ENUM ('SUCCESS', 'SKIPPED', 'FAILED');

-- CreateEnum
CREATE TYPE "DraftAutomationPublishMode" AS ENUM ('DRAFT_ONLY', 'PUBLISH_IMMEDIATELY');

-- AlterTable
ALTER TABLE "SystemCampaign" ADD COLUMN     "automationPublishMode" "DraftAutomationPublishMode" NOT NULL DEFAULT 'DRAFT_ONLY',
ADD COLUMN     "automationTemplateId" TEXT,
ADD COLUMN     "automationTemplateName" TEXT,
ADD COLUMN     "createdByAutomation" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "DraftAutomationHistory" (
    "id" TEXT NOT NULL,
    "templateId" TEXT NOT NULL,
    "templateName" TEXT NOT NULL,
    "creatorId" TEXT,
    "creatorName" TEXT,
    "creatorEmployeeId" TEXT,
    "folderId" TEXT,
    "status" "DraftAutomationRunStatus" NOT NULL,
    "reason" TEXT,
    "publishRequested" BOOLEAN NOT NULL DEFAULT false,
    "publishMode" "DraftAutomationPublishMode" NOT NULL DEFAULT 'DRAFT_ONLY',
    "publishResult" JSONB,
    "conditionSummary" JSONB,
    "steps" JSONB,
    "selectedAssets" JSONB,
    "generatedCampaignId" TEXT,
    "error" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DraftAutomationHistory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DraftAutomationHistory_templateId_createdAt_idx" ON "DraftAutomationHistory"("templateId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DraftAutomationHistory_creatorId_createdAt_idx" ON "DraftAutomationHistory"("creatorId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DraftAutomationHistory_status_createdAt_idx" ON "DraftAutomationHistory"("status", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "DraftAutomationHistory_publishRequested_createdAt_idx" ON "DraftAutomationHistory"("publishRequested", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "SystemCampaign_createdByAutomation_createdAt_idx" ON "SystemCampaign"("createdByAutomation", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "SystemCampaign_automationTemplateId_createdAt_idx" ON "SystemCampaign"("automationTemplateId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "SystemCampaign_automationPublishMode_createdAt_idx" ON "SystemCampaign"("automationPublishMode", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "DraftAutomationHistory" ADD CONSTRAINT "DraftAutomationHistory_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "TemplateCampaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;
