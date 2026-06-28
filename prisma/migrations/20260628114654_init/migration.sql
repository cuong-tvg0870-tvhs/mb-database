-- AlterTable
ALTER TABLE "SystemAd" ADD COLUMN     "publishedSnapshot" JSONB;

-- AlterTable
ALTER TABLE "SystemAdSet" ADD COLUMN     "publishedSnapshot" JSONB;

-- AlterTable
ALTER TABLE "SystemCampaign" ADD COLUMN     "publishedSnapshot" JSONB;
