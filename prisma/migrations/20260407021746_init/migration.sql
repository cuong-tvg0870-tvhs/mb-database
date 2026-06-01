/*
  Warnings:

  - A unique constraint covering the columns `[insight3dId]` on the table `Campaign` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insight7dId]` on the table `Campaign` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightMaxId]` on the table `Campaign` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightTodayId]` on the table `Campaign` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Campaign" ADD COLUMN     "insight3dId" TEXT,
ADD COLUMN     "insight7dId" TEXT,
ADD COLUMN     "insightMaxId" TEXT,
ADD COLUMN     "insightTodayId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_insight3dId_key" ON "Campaign"("insight3dId");

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_insight7dId_key" ON "Campaign"("insight7dId");

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_insightMaxId_key" ON "Campaign"("insightMaxId");

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_insightTodayId_key" ON "Campaign"("insightTodayId");

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_insight3dId_fkey" FOREIGN KEY ("insight3dId") REFERENCES "CampaignInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_insight7dId_fkey" FOREIGN KEY ("insight7dId") REFERENCES "CampaignInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_insightMaxId_fkey" FOREIGN KEY ("insightMaxId") REFERENCES "CampaignInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_insightTodayId_fkey" FOREIGN KEY ("insightTodayId") REFERENCES "CampaignInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;
