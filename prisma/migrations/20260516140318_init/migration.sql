-- AlterTable
ALTER TABLE "AdImage" ADD COLUMN     "urlExpiredAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "AdVideo" ADD COLUMN     "urlExpiredAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "urlExpiredAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "CreativeAsset" ADD COLUMN     "urlExpiredAt" TIMESTAMP(3);
