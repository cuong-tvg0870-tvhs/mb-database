-- CreateEnum
CREATE TYPE "AssetType" AS ENUM ('IMAGE', 'VIDEO');

-- CreateTable
CREATE TABLE "CreativeFolder" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "parentId" TEXT,
    "creation_time" TEXT,
    "createdAtLocal" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CreativeFolder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CreativeAsset" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "type" "AssetType" NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "thumbnail" TEXT,
    "imageUrl" TEXT,
    "imageHash" TEXT,
    "drive_url" TEXT,
    "video_id" TEXT,
    "video_source" TEXT,
    "video_thumbnails" JSONB,
    "duration" INTEGER,
    "creation_time" TEXT,
    "status" JSONB,
    "folderId" TEXT NOT NULL,
    "createdAtLocal" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "videoSource" JSONB,

    CONSTRAINT "CreativeAsset_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CreativeFolder_parentId_idx" ON "CreativeFolder"("parentId");

-- CreateIndex
CREATE INDEX "CreativeAsset_folderId_idx" ON "CreativeAsset"("folderId");

-- CreateIndex
CREATE INDEX "CreativeAsset_video_id_idx" ON "CreativeAsset"("video_id");

-- CreateIndex
CREATE INDEX "CreativeAsset_imageHash_idx" ON "CreativeAsset"("imageHash");

-- AddForeignKey
ALTER TABLE "CreativeFolder" ADD CONSTRAINT "CreativeFolder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "CreativeFolder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreativeAsset" ADD CONSTRAINT "CreativeAsset_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "CreativeFolder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
