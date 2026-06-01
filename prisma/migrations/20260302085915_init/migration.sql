/*
  Warnings:

  - A unique constraint covering the columns `[accountId,id]` on the table `AdVideo` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Creative" DROP CONSTRAINT "Creative_imageHash_fkey";

-- DropIndex
DROP INDEX "AdImage_hash_key";

-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "imageId" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "AdVideo_accountId_id_key" ON "AdVideo"("accountId", "id");

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_imageId_fkey" FOREIGN KEY ("imageId") REFERENCES "AdImage"("id") ON DELETE SET NULL ON UPDATE CASCADE;
