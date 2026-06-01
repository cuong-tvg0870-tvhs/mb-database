/*
  Warnings:

  - A unique constraint covering the columns `[insight3dId]` on the table `Ad` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insight7dId]` on the table `Ad` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightMaxId]` on the table `Ad` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightTodayId]` on the table `Ad` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insight3dId]` on the table `AdSet` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insight7dId]` on the table `AdSet` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightMaxId]` on the table `AdSet` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightTodayId]` on the table `AdSet` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Ad" ADD COLUMN     "insight3dId" TEXT,
ADD COLUMN     "insight7dId" TEXT,
ADD COLUMN     "insightMaxId" TEXT,
ADD COLUMN     "insightTodayId" TEXT;

-- AlterTable
ALTER TABLE "AdSet" ADD COLUMN     "insight3dId" TEXT,
ADD COLUMN     "insight7dId" TEXT,
ADD COLUMN     "insightMaxId" TEXT,
ADD COLUMN     "insightTodayId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Ad_insight3dId_key" ON "Ad"("insight3dId");

-- CreateIndex
CREATE UNIQUE INDEX "Ad_insight7dId_key" ON "Ad"("insight7dId");

-- CreateIndex
CREATE UNIQUE INDEX "Ad_insightMaxId_key" ON "Ad"("insightMaxId");

-- CreateIndex
CREATE UNIQUE INDEX "Ad_insightTodayId_key" ON "Ad"("insightTodayId");

-- CreateIndex
CREATE UNIQUE INDEX "AdSet_insight3dId_key" ON "AdSet"("insight3dId");

-- CreateIndex
CREATE UNIQUE INDEX "AdSet_insight7dId_key" ON "AdSet"("insight7dId");

-- CreateIndex
CREATE UNIQUE INDEX "AdSet_insightMaxId_key" ON "AdSet"("insightMaxId");

-- CreateIndex
CREATE UNIQUE INDEX "AdSet_insightTodayId_key" ON "AdSet"("insightTodayId");

-- AddForeignKey
ALTER TABLE "AdSet" ADD CONSTRAINT "AdSet_insight3dId_fkey" FOREIGN KEY ("insight3dId") REFERENCES "AdSetInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSet" ADD CONSTRAINT "AdSet_insight7dId_fkey" FOREIGN KEY ("insight7dId") REFERENCES "AdSetInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSet" ADD CONSTRAINT "AdSet_insightMaxId_fkey" FOREIGN KEY ("insightMaxId") REFERENCES "AdSetInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSet" ADD CONSTRAINT "AdSet_insightTodayId_fkey" FOREIGN KEY ("insightTodayId") REFERENCES "AdSetInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_insight3dId_fkey" FOREIGN KEY ("insight3dId") REFERENCES "AdInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_insight7dId_fkey" FOREIGN KEY ("insight7dId") REFERENCES "AdInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_insightMaxId_fkey" FOREIGN KEY ("insightMaxId") REFERENCES "AdInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_insightTodayId_fkey" FOREIGN KEY ("insightTodayId") REFERENCES "AdInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;
