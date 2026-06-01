/*
  Warnings:

  - You are about to drop the column `drive_permission` on the `LarkRecord` table. All the data in the column will be lost.
  - You are about to drop the column `drive_url` on the `LarkRecord` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[imageHash]` on the table `CreativeAsset` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[drive_url]` on the table `CreativeAsset` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[drive_id]` on the table `CreativeAsset` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[video_id]` on the table `CreativeAsset` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[cid]` on the table `LarkRecord` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[drive_id]` on the table `LarkRecord` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[creative_asset_id]` on the table `LarkRecord` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "CreativeAsset_imageHash_idx";

-- DropIndex
DROP INDEX "CreativeAsset_video_id_idx";

-- DropIndex
DROP INDEX "LarkRecord_creative_asset_id_idx";

-- AlterTable
ALTER TABLE "CreativeAsset" ADD COLUMN     "drive_id" TEXT;

-- AlterTable
ALTER TABLE "LarkRecord" DROP COLUMN "drive_permission",
DROP COLUMN "drive_url",
ADD COLUMN     "drive_id" TEXT;

-- CreateTable
CREATE TABLE "DriveFile" (
    "id" TEXT NOT NULL,
    "raw" JSONB NOT NULL,
    "parentId" TEXT,
    "name" TEXT,
    "mimeType" TEXT,
    "webContentLink" TEXT,
    "webViewLink" TEXT,
    "size" TEXT,
    "drive_permission" BOOLEAN,

    CONSTRAINT "DriveFile_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "CreativeAsset_imageHash_key" ON "CreativeAsset"("imageHash");

-- CreateIndex
CREATE UNIQUE INDEX "CreativeAsset_drive_url_key" ON "CreativeAsset"("drive_url");

-- CreateIndex
CREATE UNIQUE INDEX "CreativeAsset_drive_id_key" ON "CreativeAsset"("drive_id");

-- CreateIndex
CREATE UNIQUE INDEX "CreativeAsset_video_id_key" ON "CreativeAsset"("video_id");

-- CreateIndex
CREATE UNIQUE INDEX "LarkRecord_cid_key" ON "LarkRecord"("cid");

-- CreateIndex
CREATE UNIQUE INDEX "LarkRecord_drive_id_key" ON "LarkRecord"("drive_id");

-- CreateIndex
CREATE UNIQUE INDEX "LarkRecord_creative_asset_id_key" ON "LarkRecord"("creative_asset_id");

-- AddForeignKey
ALTER TABLE "CreativeAsset" ADD CONSTRAINT "CreativeAsset_drive_id_fkey" FOREIGN KEY ("drive_id") REFERENCES "DriveFile"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LarkRecord" ADD CONSTRAINT "LarkRecord_drive_id_fkey" FOREIGN KEY ("drive_id") REFERENCES "DriveFile"("id") ON DELETE SET NULL ON UPDATE CASCADE;
