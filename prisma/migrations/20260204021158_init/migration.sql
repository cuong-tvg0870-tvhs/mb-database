/*
  Warnings:

  - You are about to drop the column `adSetId` on the `AdInsight` table. All the data in the column will be lost.
  - You are about to drop the column `campaignId` on the `AdInsight` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "AdSetInsight" DROP CONSTRAINT "AdSetInsight_campaignId_fkey";

-- DropIndex
DROP INDEX "AdInsight_campaignId_idx";

-- DropIndex
DROP INDEX "AdSetInsight_campaignId_idx";

-- AlterTable
ALTER TABLE "Ad" ADD COLUMN     "actionValues" JSONB,
ADD COLUMN     "actions" JSONB,
ADD COLUMN     "adsCostRatio" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "clicks" INTEGER DEFAULT 0,
ADD COLUMN     "conversionRateRanking" TEXT,
ADD COLUMN     "costPerResult" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpc" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpm" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "ctr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cvr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "engagementRateRanking" TEXT,
ADD COLUMN     "frequency" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "impressions" INTEGER DEFAULT 0,
ADD COLUMN     "purchaseRoas" JSONB,
ADD COLUMN     "purchaseValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "purchases" INTEGER DEFAULT 0,
ADD COLUMN     "qualityRanking" TEXT,
ADD COLUMN     "reach" INTEGER DEFAULT 0,
ADD COLUMN     "results" INTEGER DEFAULT 0,
ADD COLUMN     "roas" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasCalculated" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasMeta" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "spend" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "uniqueClicks" INTEGER DEFAULT 0,
ADD COLUMN     "uniqueCtr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoAvgWatchTime" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoThruplay" INTEGER DEFAULT 0,
ADD COLUMN     "videoView" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "AdInsight" DROP COLUMN "adSetId",
DROP COLUMN "campaignId";

-- AlterTable
ALTER TABLE "AdSet" ADD COLUMN     "actionValues" JSONB,
ADD COLUMN     "actions" JSONB,
ADD COLUMN     "adsCostRatio" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "clicks" INTEGER DEFAULT 0,
ADD COLUMN     "conversionRateRanking" TEXT,
ADD COLUMN     "costPerResult" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpc" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpm" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "ctr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cvr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "effectiveBudget" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "engagementRateRanking" TEXT,
ADD COLUMN     "frequency" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "impressions" INTEGER DEFAULT 0,
ADD COLUMN     "purchaseRoas" JSONB,
ADD COLUMN     "purchaseValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "purchases" INTEGER DEFAULT 0,
ADD COLUMN     "qualityRanking" TEXT,
ADD COLUMN     "reach" INTEGER DEFAULT 0,
ADD COLUMN     "results" INTEGER DEFAULT 0,
ADD COLUMN     "roas" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasCalculated" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasMeta" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "spend" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "uniqueClicks" INTEGER DEFAULT 0,
ADD COLUMN     "uniqueCtr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoAvgWatchTime" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoThruplay" INTEGER DEFAULT 0,
ADD COLUMN     "videoView" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "AdSetInsight" ALTER COLUMN "campaignId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Campaign" ADD COLUMN     "actionValues" JSONB,
ADD COLUMN     "actions" JSONB,
ADD COLUMN     "adsCostRatio" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "clicks" INTEGER DEFAULT 0,
ADD COLUMN     "conversionRateRanking" TEXT,
ADD COLUMN     "costPerResult" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpc" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpm" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "ctr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cvr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "effectiveBudget" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "engagementRateRanking" TEXT,
ADD COLUMN     "frequency" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "impressions" INTEGER DEFAULT 0,
ADD COLUMN     "purchaseRoas" JSONB,
ADD COLUMN     "purchaseValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "purchases" INTEGER DEFAULT 0,
ADD COLUMN     "qualityRanking" TEXT,
ADD COLUMN     "reach" INTEGER DEFAULT 0,
ADD COLUMN     "results" INTEGER DEFAULT 0,
ADD COLUMN     "roas" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasCalculated" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasMeta" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "spend" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "uniqueClicks" INTEGER DEFAULT 0,
ADD COLUMN     "uniqueCtr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoAvgWatchTime" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoThruplay" INTEGER DEFAULT 0,
ADD COLUMN     "videoView" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "actionValues" JSONB,
ADD COLUMN     "actions" JSONB,
ADD COLUMN     "adsCostRatio" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "clicks" INTEGER DEFAULT 0,
ADD COLUMN     "conversionRateRanking" TEXT,
ADD COLUMN     "costPerResult" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpc" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cpm" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "ctr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "cvr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "engagementRateRanking" TEXT,
ADD COLUMN     "frequency" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "impressions" INTEGER DEFAULT 0,
ADD COLUMN     "purchaseRoas" JSONB,
ADD COLUMN     "purchaseValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "purchases" INTEGER DEFAULT 0,
ADD COLUMN     "qualityRanking" TEXT,
ADD COLUMN     "reach" INTEGER DEFAULT 0,
ADD COLUMN     "results" INTEGER DEFAULT 0,
ADD COLUMN     "roas" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasCalculated" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "roasMeta" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "spend" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "uniqueClicks" INTEGER DEFAULT 0,
ADD COLUMN     "uniqueCtr" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoAvgWatchTime" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "videoThruplay" INTEGER DEFAULT 0,
ADD COLUMN     "videoView" INTEGER DEFAULT 0;

-- CreateTable
CREATE TABLE "CreativeInsight" (
    "id" TEXT NOT NULL,
    "creativeId" TEXT NOT NULL,
    "level" "LevelInsight" NOT NULL DEFAULT 'AD',
    "dateStart" TEXT NOT NULL,
    "dateStop" TEXT NOT NULL,
    "range" "InsightRange" NOT NULL DEFAULT 'DAILY',
    "impressions" INTEGER NOT NULL,
    "reach" INTEGER,
    "frequency" DOUBLE PRECISION,
    "clicks" INTEGER NOT NULL,
    "uniqueClicks" INTEGER,
    "ctr" DOUBLE PRECISION,
    "uniqueCtr" DOUBLE PRECISION,
    "cpc" DOUBLE PRECISION,
    "cpm" DOUBLE PRECISION,
    "spend" DOUBLE PRECISION NOT NULL,
    "results" INTEGER,
    "costPerResult" DOUBLE PRECISION,
    "purchases" INTEGER,
    "purchaseValue" DOUBLE PRECISION,
    "roas" DOUBLE PRECISION,
    "actions" JSONB,
    "actionValues" JSONB,
    "purchaseRoas" JSONB,
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "campaignId" TEXT,

    CONSTRAINT "CreativeInsight_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CampaignAudienceInsight" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "level" "LevelInsight" NOT NULL DEFAULT 'CAMPAIGN',
    "dateStart" TEXT,
    "dateStop" TEXT,
    "range" "InsightRange" NOT NULL DEFAULT 'MAX',
    "age" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "impressions" INTEGER NOT NULL,
    "reach" INTEGER,
    "frequency" DOUBLE PRECISION,
    "clicks" INTEGER NOT NULL,
    "uniqueClicks" INTEGER,
    "ctr" DOUBLE PRECISION,
    "uniqueCtr" DOUBLE PRECISION,
    "cpc" DOUBLE PRECISION,
    "cpm" DOUBLE PRECISION,
    "spend" DOUBLE PRECISION NOT NULL,
    "results" INTEGER,
    "costPerResult" DOUBLE PRECISION,
    "purchases" INTEGER,
    "purchaseValue" DOUBLE PRECISION,
    "roas" DOUBLE PRECISION,
    "qualityRanking" TEXT,
    "engagementRateRanking" TEXT,
    "conversionRateRanking" TEXT,
    "actions" JSONB,
    "actionValues" JSONB,
    "purchaseRoas" JSONB,
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CampaignAudienceInsight_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CreativeInsight_creativeId_idx" ON "CreativeInsight"("creativeId");

-- CreateIndex
CREATE UNIQUE INDEX "CreativeInsight_creativeId_dateStart_dateStop_range_key" ON "CreativeInsight"("creativeId", "dateStart", "dateStop", "range");

-- CreateIndex
CREATE INDEX "CampaignAudienceInsight_campaignId_idx" ON "CampaignAudienceInsight"("campaignId");

-- CreateIndex
CREATE INDEX "CampaignAudienceInsight_age_gender_idx" ON "CampaignAudienceInsight"("age", "gender");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignAudienceInsight_campaignId_age_gender_range_key" ON "CampaignAudienceInsight"("campaignId", "age", "gender", "range");

-- AddForeignKey
ALTER TABLE "CreativeInsight" ADD CONSTRAINT "CreativeInsight_creativeId_fkey" FOREIGN KEY ("creativeId") REFERENCES "Creative"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreativeInsight" ADD CONSTRAINT "CreativeInsight_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSetInsight" ADD CONSTRAINT "AdSetInsight_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CampaignAudienceInsight" ADD CONSTRAINT "CampaignAudienceInsight_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;
