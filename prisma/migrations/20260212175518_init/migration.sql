-- CreateTable
CREATE TABLE "AdAudienceInsight" (
    "id" TEXT NOT NULL,
    "adId" TEXT NOT NULL,
    "level" "LevelInsight" NOT NULL DEFAULT 'AD',
    "dateStart" TEXT,
    "dateStop" TEXT,
    "range" "InsightRange" NOT NULL DEFAULT 'MAX',
    "age" TEXT NOT NULL,
    "gender" TEXT NOT NULL,
    "impressions" INTEGER DEFAULT 0,
    "reach" INTEGER DEFAULT 0,
    "frequency" DOUBLE PRECISION DEFAULT 0,
    "clicks" INTEGER DEFAULT 0,
    "uniqueClicks" INTEGER DEFAULT 0,
    "ctr" DOUBLE PRECISION DEFAULT 0,
    "uniqueCtr" DOUBLE PRECISION DEFAULT 0,
    "cpc" DOUBLE PRECISION DEFAULT 0,
    "cpm" DOUBLE PRECISION DEFAULT 0,
    "spend" DOUBLE PRECISION DEFAULT 0,
    "results" INTEGER DEFAULT 0,
    "costPerResult" DOUBLE PRECISION DEFAULT 0,
    "aov" INTEGER DEFAULT 0,
    "purchases" INTEGER DEFAULT 0,
    "purchaseValue" DOUBLE PRECISION DEFAULT 0,
    "roas" DOUBLE PRECISION DEFAULT 0,
    "registrationComplete" INTEGER DEFAULT 0,
    "registrationCompleteValue" DOUBLE PRECISION DEFAULT 0,
    "messagingStarted" INTEGER DEFAULT 0,
    "messagingStartedValue" DOUBLE PRECISION DEFAULT 0,
    "outboundClicks" INTEGER DEFAULT 0,
    "outboundClicksValue" DOUBLE PRECISION DEFAULT 0,
    "cvr" DOUBLE PRECISION DEFAULT 0,
    "adsCostRatio" DOUBLE PRECISION DEFAULT 0,
    "qualityRanking" TEXT,
    "engagementRateRanking" TEXT,
    "conversionRateRanking" TEXT,
    "actions" JSONB,
    "actionValues" JSONB,
    "videoPlay" DOUBLE PRECISION DEFAULT 0,
    "video3s" DOUBLE PRECISION DEFAULT 0,
    "video100" DOUBLE PRECISION DEFAULT 0,
    "videoAvgWatchTime" DOUBLE PRECISION DEFAULT 0,
    "videoThruplay" INTEGER DEFAULT 0,
    "videoView" INTEGER DEFAULT 0,
    "hookRate" DOUBLE PRECISION DEFAULT 0,
    "holdRate" DOUBLE PRECISION DEFAULT 0,
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdAudienceInsight_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AdAudienceInsight_adId_idx" ON "AdAudienceInsight"("adId");

-- CreateIndex
CREATE INDEX "AdAudienceInsight_age_gender_idx" ON "AdAudienceInsight"("age", "gender");

-- CreateIndex
CREATE UNIQUE INDEX "AdAudienceInsight_adId_age_gender_level_range_dateStart_key" ON "AdAudienceInsight"("adId", "age", "gender", "level", "range", "dateStart");

-- AddForeignKey
ALTER TABLE "AdAudienceInsight" ADD CONSTRAINT "AdAudienceInsight_adId_fkey" FOREIGN KEY ("adId") REFERENCES "Ad"("id") ON DELETE CASCADE ON UPDATE CASCADE;
