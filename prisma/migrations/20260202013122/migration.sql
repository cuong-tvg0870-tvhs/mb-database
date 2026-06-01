/*
  Warnings:

  - The `level` column on the `AdInsight` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `adset_bidStrategy` column on the `SystemAdSet` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `campaign_objective` column on the `SystemCampaign` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `campaign_bidStrategy` column on the `SystemCampaign` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - A unique constraint covering the columns `[adId,dateStart,dateStop,range]` on the table `AdInsight` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `adSetId` to the `AdInsight` table without a default value. This is not possible if the table is not empty.
  - Added the required column `campaignId` to the `AdInsight` table without a default value. This is not possible if the table is not empty.
  - Made the column `adId` on table `AdInsight` required. This step will fail if there are existing NULL values in that column.
  - Made the column `range` on table `AdInsight` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "LevelInsight" AS ENUM ('AD', 'CAMPAIGN', 'ADSET');

-- DropIndex
DROP INDEX "AdInsight_adId_dateStart_dateStop_key";

-- AlterTable
ALTER TABLE "AdInsight" ADD COLUMN     "adSetId" TEXT NOT NULL,
ADD COLUMN     "avgWatchTime" DOUBLE PRECISION,
ADD COLUMN     "campaignId" TEXT NOT NULL,
ADD COLUMN     "purchaseValue" DOUBLE PRECISION,
ADD COLUMN     "purchases" INTEGER,
ADD COLUMN     "roas" DOUBLE PRECISION,
ADD COLUMN     "thruPlays" INTEGER,
ADD COLUMN     "videoViews" INTEGER,
DROP COLUMN "level",
ADD COLUMN     "level" "LevelInsight" NOT NULL DEFAULT 'AD',
ALTER COLUMN "adId" SET NOT NULL,
ALTER COLUMN "uniqueCtr" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "range" SET NOT NULL,
ALTER COLUMN "range" SET DEFAULT 'DAILY';

-- AlterTable
ALTER TABLE "SystemAdSet" DROP COLUMN "adset_bidStrategy",
ADD COLUMN     "adset_bidStrategy" TEXT;

-- AlterTable
ALTER TABLE "SystemCampaign" DROP COLUMN "campaign_objective",
ADD COLUMN     "campaign_objective" TEXT,
DROP COLUMN "campaign_bidStrategy",
ADD COLUMN     "campaign_bidStrategy" TEXT;

-- DropEnum
DROP TYPE "BidStrategy";

-- DropEnum
DROP TYPE "BuyingType";

-- DropEnum
DROP TYPE "CampaignObjective";

-- DropEnum
DROP TYPE "DestinationType";

-- DropEnum
DROP TYPE "MediaType";

-- CreateTable
CREATE TABLE "CampaignInsight" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "level" "LevelInsight" NOT NULL DEFAULT 'CAMPAIGN',
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
    "qualityRanking" TEXT,
    "engagementRateRanking" TEXT,
    "conversionRateRanking" TEXT,
    "actions" JSONB,
    "actionValues" JSONB,
    "purchaseRoas" JSONB,
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CampaignInsight_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdSetInsight" (
    "id" TEXT NOT NULL,
    "adSetId" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "level" "LevelInsight" NOT NULL DEFAULT 'ADSET',
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

    CONSTRAINT "AdSetInsight_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CampaignInsight_campaignId_idx" ON "CampaignInsight"("campaignId");

-- CreateIndex
CREATE INDEX "CampaignInsight_dateStart_dateStop_idx" ON "CampaignInsight"("dateStart", "dateStop");

-- CreateIndex
CREATE UNIQUE INDEX "CampaignInsight_campaignId_dateStart_dateStop_range_key" ON "CampaignInsight"("campaignId", "dateStart", "dateStop", "range");

-- CreateIndex
CREATE INDEX "AdSetInsight_adSetId_idx" ON "AdSetInsight"("adSetId");

-- CreateIndex
CREATE INDEX "AdSetInsight_campaignId_idx" ON "AdSetInsight"("campaignId");

-- CreateIndex
CREATE UNIQUE INDEX "AdSetInsight_adSetId_dateStart_dateStop_range_key" ON "AdSetInsight"("adSetId", "dateStart", "dateStop", "range");

-- CreateIndex
CREATE INDEX "AdInsight_adId_idx" ON "AdInsight"("adId");

-- CreateIndex
CREATE INDEX "AdInsight_campaignId_idx" ON "AdInsight"("campaignId");

-- CreateIndex
CREATE UNIQUE INDEX "AdInsight_adId_dateStart_dateStop_range_key" ON "AdInsight"("adId", "dateStart", "dateStop", "range");

-- AddForeignKey
ALTER TABLE "CampaignInsight" ADD CONSTRAINT "CampaignInsight_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSetInsight" ADD CONSTRAINT "AdSetInsight_adSetId_fkey" FOREIGN KEY ("adSetId") REFERENCES "AdSet"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSetInsight" ADD CONSTRAINT "AdSetInsight_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;
