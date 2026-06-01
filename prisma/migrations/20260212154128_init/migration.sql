-- AlterTable
ALTER TABLE "Ad" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "AdInsight" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "AdSet" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "AdSetInsight" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "AdsetAudienceInsight" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "Campaign" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "CampaignAudienceInsight" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "CampaignInsight" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;

-- AlterTable
ALTER TABLE "CreativeInsight" ADD COLUMN     "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
ADD COLUMN     "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0;
