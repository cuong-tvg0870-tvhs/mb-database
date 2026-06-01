/*
  Warnings:

  - You are about to drop the `Planning` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropIndex
DROP INDEX "Creative_accountId_idx";

-- DropTable
DROP TABLE "Planning";

-- DropEnum
DROP TYPE "PlanningStatus";

-- DropEnum
DROP TYPE "PlanningType";

-- CreateIndex
CREATE INDEX "Creative_accountId_createdAt_idx" ON "Creative"("accountId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Creative_accountId_creativeType_createdAt_idx" ON "Creative"("accountId", "creativeType", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Creative_accountId_remoteUpdatedAt_idx" ON "Creative"("accountId", "remoteUpdatedAt" DESC);

-- CreateIndex
CREATE INDEX "Creative_adId_idx" ON "Creative"("adId");

-- CreateIndex
CREATE INDEX "SystemAd_status_idx" ON "SystemAd"("status");

-- CreateIndex
CREATE INDEX "SystemAd_createdById_createdAt_idx" ON "SystemAd"("createdById", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "SystemAdSet_status_idx" ON "SystemAdSet"("status");

-- CreateIndex
CREATE INDEX "SystemAdSet_createdById_createdAt_idx" ON "SystemAdSet"("createdById", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "SystemCampaign_status_idx" ON "SystemCampaign"("status");

-- CreateIndex
CREATE INDEX "SystemCampaign_createdById_createdAt_idx" ON "SystemCampaign"("createdById", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "SystemCreative_status_idx" ON "SystemCreative"("status");

-- CreateIndex
CREATE INDEX "SystemCreative_createdById_createdAt_idx" ON "SystemCreative"("createdById", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "TemplateCampaign_name_idx" ON "TemplateCampaign"("name");

-- CreateIndex
CREATE INDEX "TemplateCampaign_reference_id_idx" ON "TemplateCampaign"("reference_id");

-- CreateIndex
CREATE INDEX "TemplateCampaign_createdById_createdAt_idx" ON "TemplateCampaign"("createdById", "createdAt" DESC);
