-- AlterTable
ALTER TABLE "Ad" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "AdInsight" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "AdSet" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "AdSetInsight" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "AdsetAudienceInsight" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "Campaign" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "CampaignAudienceInsight" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "CampaignInsight" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "aov" INTEGER DEFAULT 0;

-- AlterTable
ALTER TABLE "CreativeInsight" ADD COLUMN     "aov" INTEGER DEFAULT 0;
