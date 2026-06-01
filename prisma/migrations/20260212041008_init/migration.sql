/*
  Warnings:

  - You are about to drop the column `purchaseRoas` on the `Ad` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `Ad` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `Ad` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `AdInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `AdInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `AdInsight` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `AdSet` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `AdSet` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `AdSet` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `AdSetInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `AdSetInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `AdSetInsight` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `Campaign` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `Campaign` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `Campaign` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `CampaignAudienceInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `CampaignAudienceInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `CampaignAudienceInsight` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `CampaignInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `CampaignInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `CampaignInsight` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `Creative` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `Creative` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `Creative` table. All the data in the column will be lost.
  - You are about to drop the column `purchaseRoas` on the `CreativeInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasCalculated` on the `CreativeInsight` table. All the data in the column will be lost.
  - You are about to drop the column `roasMeta` on the `CreativeInsight` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[adId,dateStart,range]` on the table `AdInsight` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[adSetId,dateStart,range]` on the table `AdSetInsight` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[campaignId,dateStart,range]` on the table `CampaignInsight` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[creativeId,dateStart,range]` on the table `CreativeInsight` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "AdInsight_adId_dateStart_dateStop_range_key";

-- DropIndex
DROP INDEX "AdSetInsight_adSetId_dateStart_dateStop_range_key";

-- DropIndex
DROP INDEX "CampaignInsight_campaignId_dateStart_dateStop_range_key";

-- DropIndex
DROP INDEX "CreativeInsight_creativeId_dateStart_dateStop_range_key";

-- AlterTable
ALTER TABLE "Ad" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "AdImage" ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "AdInsight" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "AdSet" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "AdSetInsight" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "AdVideo" ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Campaign" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "CampaignAudienceInsight" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "CampaignInsight" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Creative" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "CreativeInsight" DROP COLUMN "purchaseRoas",
DROP COLUMN "roasCalculated",
DROP COLUMN "roasMeta",
ADD COLUMN     "messagingStarted" INTEGER DEFAULT 0,
ADD COLUMN     "outboundClicks" INTEGER DEFAULT 0,
ADD COLUMN     "registrationComplete" INTEGER DEFAULT 0,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- CreateTable
CREATE TABLE "AdsetAudienceInsight" (
    "id" TEXT NOT NULL,
    "adsetId" TEXT NOT NULL,
    "level" "LevelInsight" NOT NULL DEFAULT 'ADSET',
    "dateStart" TEXT,
    "dateStop" TEXT,
    "range" "InsightRange" NOT NULL DEFAULT 'MAX',
    "age" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "impressions" INTEGER DEFAULT 0,
    "reach" INTEGER DEFAULT 0,
    "frequency" DOUBLE PRECISION DEFAULT 0,
    "clicks" INTEGER DEFAULT 0,
    "uniqueClicks" INTEGER DEFAULT 0,
    "ctr" DOUBLE PRECISION DEFAULT 0,
    "uniqueCtr" DOUBLE PRECISION DEFAULT 0,
    "cpc" DOUBLE PRECISION DEFAULT 0,
    "cpm" DOUBLE PRECISION DEFAULT 0,
    "spend" DOUBLE PRECISION DEFAULT 0,
    "results" INTEGER DEFAULT 0,
    "costPerResult" DOUBLE PRECISION DEFAULT 0,
    "purchases" INTEGER DEFAULT 0,
    "purchaseValue" DOUBLE PRECISION DEFAULT 0,
    "roas" DOUBLE PRECISION DEFAULT 0,
    "registrationComplete" INTEGER DEFAULT 0,
    "messagingStarted" INTEGER DEFAULT 0,
    "outboundClicks" INTEGER DEFAULT 0,
    "cvr" DOUBLE PRECISION DEFAULT 0,
    "adsCostRatio" DOUBLE PRECISION DEFAULT 0,
    "qualityRanking" TEXT,
    "engagementRateRanking" TEXT,
    "conversionRateRanking" TEXT,
    "actions" JSONB,
    "actionValues" JSONB,
    "videoPlay" DOUBLE PRECISION DEFAULT 0,
    "video3s" DOUBLE PRECISION DEFAULT 0,
    "video100" DOUBLE PRECISION DEFAULT 0,
    "videoAvgWatchTime" DOUBLE PRECISION DEFAULT 0,
    "videoThruplay" INTEGER DEFAULT 0,
    "videoView" INTEGER DEFAULT 0,
    "hookRate" DOUBLE PRECISION DEFAULT 0,
    "holdRate" DOUBLE PRECISION DEFAULT 0,
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdsetAudienceInsight_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AdsetAudienceInsight_adsetId_idx" ON "AdsetAudienceInsight"("adsetId");

-- CreateIndex
CREATE INDEX "AdsetAudienceInsight_age_gender_idx" ON "AdsetAudienceInsight"("age", "gender");

-- CreateIndex
CREATE UNIQUE INDEX "AdsetAudienceInsight_adsetId_age_gender_level_range_dateSta_key" ON "AdsetAudienceInsight"("adsetId", "age", "gender", "level", "range", "dateStart");

-- CreateIndex
CREATE UNIQUE INDEX "AdInsight_adId_dateStart_range_key" ON "AdInsight"("adId", "dateStart", "range");

-- CreateIndex
CREATE UNIQUE INDEX "AdSetInsight_adSetId_dateStart_range_key" ON "AdSetInsight"("adSetId", "dateStart", "range");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignInsight_campaignId_dateStart_range_key" ON "CampaignInsight"("campaignId", "dateStart", "range");

-- CreateIndex
CREATE UNIQUE INDEX "CreativeInsight_creativeId_dateStart_range_key" ON "CreativeInsight"("creativeId", "dateStart", "range");

-- AddForeignKey
ALTER TABLE "AdsetAudienceInsight" ADD CONSTRAINT "AdsetAudienceInsight_adsetId_fkey" FOREIGN KEY ("adsetId") REFERENCES "AdSet"("id") ON DELETE CASCADE ON UPDATE CASCADE;
