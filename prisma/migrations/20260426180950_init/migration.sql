-- DropForeignKey
ALTER TABLE "CreativeAsset" DROP CONSTRAINT "CreativeAsset_folderId_fkey";

-- DropForeignKey
ALTER TABLE "CreativeFolder" DROP CONSTRAINT "CreativeFolder_parentId_fkey";

-- AddForeignKey
ALTER TABLE "CreativeFolder" ADD CONSTRAINT "CreativeFolder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "CreativeFolder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreativeAsset" ADD CONSTRAINT "CreativeAsset_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "CreativeFolder"("id") ON DELETE CASCADE ON UPDATE CASCADE;
