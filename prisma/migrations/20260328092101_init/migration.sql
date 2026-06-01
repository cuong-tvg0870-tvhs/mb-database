-- DropIndex
DROP INDEX "Ad_accountId_idx";

-- DropIndex
DROP INDEX "Ad_adsetId_idx";

-- DropIndex
DROP INDEX "Ad_status_idx";

-- DropIndex
DROP INDEX "AdSet_accountId_idx";

-- DropIndex
DROP INDEX "AdSet_campaignId_idx";

-- DropIndex
DROP INDEX "AdSet_status_idx";

-- DropIndex
DROP INDEX "Campaign_accountId_idx";

-- DropIndex
DROP INDEX "Campaign_remoteUpdatedAt_idx";

-- DropIndex
DROP INDEX "Campaign_status_idx";

-- CreateIndex
CREATE INDEX "Ad_adsetId_updatedAt_idx" ON "Ad"("adsetId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Ad_campaignId_updatedAt_idx" ON "Ad"("campaignId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Ad_accountId_updatedAt_idx" ON "Ad"("accountId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Ad_accountId_status_updatedAt_idx" ON "Ad"("accountId", "status", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Ad_accountId_remoteUpdatedAt_idx" ON "Ad"("accountId", "remoteUpdatedAt" DESC);

-- CreateIndex
CREATE INDEX "Ad_cid_idx" ON "Ad"("cid");

-- CreateIndex
CREATE INDEX "Ad_adsetId_updatedAt_id_idx" ON "Ad"("adsetId", "updatedAt" DESC, "id");

-- CreateIndex
CREATE INDEX "Ad_accountId_deletedAt_updatedAt_idx" ON "Ad"("accountId", "deletedAt", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AdSet_campaignId_updatedAt_idx" ON "AdSet"("campaignId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AdSet_accountId_updatedAt_idx" ON "AdSet"("accountId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AdSet_accountId_status_updatedAt_idx" ON "AdSet"("accountId", "status", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AdSet_accountId_remoteUpdatedAt_idx" ON "AdSet"("accountId", "remoteUpdatedAt" DESC);

-- CreateIndex
CREATE INDEX "AdSet_accountId_deletedAt_updatedAt_idx" ON "AdSet"("accountId", "deletedAt", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AdSet_campaignId_updatedAt_id_idx" ON "AdSet"("campaignId", "updatedAt" DESC, "id");

-- CreateIndex
CREATE INDEX "Campaign_accountId_updatedAt_idx" ON "Campaign"("accountId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Campaign_accountId_status_updatedAt_idx" ON "Campaign"("accountId", "status", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Campaign_accountId_remoteUpdatedAt_idx" ON "Campaign"("accountId", "remoteUpdatedAt" DESC);

-- CreateIndex
CREATE INDEX "Campaign_accountId_deletedAt_updatedAt_idx" ON "Campaign"("accountId", "deletedAt", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "Campaign_accountId_updatedAt_id_idx" ON "Campaign"("accountId", "updatedAt" DESC, "id");
