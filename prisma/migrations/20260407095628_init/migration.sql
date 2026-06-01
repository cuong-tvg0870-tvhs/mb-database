/*
  Warnings:

  - A unique constraint covering the columns `[insight3dId]` on the table `Creative` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insight7dId]` on the table `Creative` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightMaxId]` on the table `Creative` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[insightTodayId]` on the table `Creative` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "insight3dId" TEXT,
ADD COLUMN     "insight7dId" TEXT,
ADD COLUMN     "insightMaxId" TEXT,
ADD COLUMN     "insightTodayId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Creative_insight3dId_key" ON "Creative"("insight3dId");

-- CreateIndex
CREATE UNIQUE INDEX "Creative_insight7dId_key" ON "Creative"("insight7dId");

-- CreateIndex
CREATE UNIQUE INDEX "Creative_insightMaxId_key" ON "Creative"("insightMaxId");

-- CreateIndex
CREATE UNIQUE INDEX "Creative_insightTodayId_key" ON "Creative"("insightTodayId");

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_insight3dId_fkey" FOREIGN KEY ("insight3dId") REFERENCES "CreativeInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_insight7dId_fkey" FOREIGN KEY ("insight7dId") REFERENCES "CreativeInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_insightMaxId_fkey" FOREIGN KEY ("insightMaxId") REFERENCES "CreativeInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_insightTodayId_fkey" FOREIGN KEY ("insightTodayId") REFERENCES "CreativeInsight"("id") ON DELETE SET NULL ON UPDATE CASCADE;
