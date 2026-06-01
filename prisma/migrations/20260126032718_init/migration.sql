-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'EDITOR');

-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('AD_ACCOUNT', 'PAGE', 'INSTAGRAM', 'BUSINESS_MANAGER');

-- CreateEnum
CREATE TYPE "MemberRole" AS ENUM ('OWNER', 'MANAGER', 'EDITOR', 'VIEWER');

-- CreateEnum
CREATE TYPE "CidStatus" AS ENUM ('TEST', 'NEED_TO_SPEND', 'SCALE_P1', 'SCALE_P2', 'REVIEW', 'OFF');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('DRAFT', 'ACTIVE', 'PAUSED', 'DELETED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "InsightRange" AS ENUM ('MAX', 'DAY_7', 'DAY_3', 'DAILY');

-- CreateEnum
CREATE TYPE "CampaignObjective" AS ENUM ('OUTCOME_AWARENESS', 'OUTCOME_TRAFFIC', 'OUTCOME_ENGAGEMENT', 'OUTCOME_LEADS', 'OUTCOME_APP_PROMOTION', 'OUTCOME_SALES');

-- CreateEnum
CREATE TYPE "BuyingType" AS ENUM ('AUCTION', 'RESERVATION');

-- CreateEnum
CREATE TYPE "BidStrategy" AS ENUM ('LOWEST_COST_WITHOUT_CAP', 'LOWEST_COST_WITH_BID_CAP', 'COST_CAP', 'LOWEST_COST_WITH_MIN_ROAS');

-- CreateEnum
CREATE TYPE "MediaType" AS ENUM ('IMAGE', 'VIDEO', 'CAROUSEL');

-- CreateEnum
CREATE TYPE "DestinationType" AS ENUM ('WEBSITE', 'APP', 'MESSENGER', 'WHATSAPP', 'INSTAGRAM_DIRECT', 'ON_AD', 'ON_PAGE', 'FACEBOOK_PAGE');

-- CreateTable
CREATE TABLE "TargetingInterest" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "audience_size_lower_bound" INTEGER,
    "audience_size_upper_bound" INTEGER,
    "path" JSONB,
    "topic" TEXT,

    CONSTRAINT "TargetingInterest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CidContent" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "project_name" TEXT,
    "ma_sanpham" TEXT,
    "ten_sanpham" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CidContent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DropdownCategory" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "updatedById" TEXT,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DropdownCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DropdownItem" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "externalId" TEXT,
    "name" TEXT NOT NULL,
    "value" TEXT,
    "description" TEXT,
    "color" TEXT,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "updatedById" TEXT,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "DropdownItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "employee_id" TEXT,
    "name" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'EDITOR',
    "parentId" TEXT,
    "locale" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdById" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "updatedById" TEXT,
    "deletedAt" TIMESTAMP(3),
    "deletedById" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserFanpage" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,
    "name" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserFanpage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Fanpage" (
    "id" TEXT NOT NULL,
    "name" TEXT,

    CONSTRAINT "Fanpage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "accountType" "AccountType" NOT NULL,
    "name" TEXT,
    "currency" TEXT,
    "timezone" TEXT,
    "needsReauth" BOOLEAN NOT NULL DEFAULT false,
    "lastFetchedAt" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "pages" JSONB,
    "pixels" JSONB,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AccountMember" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "MemberRole" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AccountMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Campaign" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "systemCampaignId" TEXT,
    "name" TEXT,
    "status" TEXT,
    "objective" TEXT,
    "buyingType" TEXT,
    "dailyBudget" INTEGER,
    "lifetimeBudget" INTEGER,
    "startTime" TIMESTAMP(3),
    "endTime" TIMESTAMP(3),
    "remoteUpdatedAt" TIMESTAMP(3),
    "lastFetchedAt" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Campaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdSet" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "name" TEXT,
    "status" TEXT,
    "optimizationGoal" TEXT,
    "billingEvent" TEXT,
    "bidStrategy" TEXT,
    "dailyBudget" INTEGER,
    "lifetimeBudget" INTEGER,
    "targeting" JSONB,
    "startTime" TIMESTAMP(3),
    "endTime" TIMESTAMP(3),
    "remoteUpdatedAt" TIMESTAMP(3),
    "lastFetchedAt" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AdSet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ad" (
    "id" TEXT NOT NULL,
    "adsetId" TEXT NOT NULL,
    "cid" TEXT,
    "campaignId" TEXT,
    "accountId" TEXT,
    "name" TEXT,
    "status" TEXT,
    "effectiveStatus" TEXT,
    "configuredStatus" TEXT,
    "creativeId" TEXT,
    "remoteUpdatedAt" TIMESTAMP(3),
    "lastFetchedAt" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Ad_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CID" (
    "id" TEXT NOT NULL,
    "cid" TEXT NOT NULL,
    "accountId" TEXT,
    "name" TEXT,
    "description" TEXT,
    "spentMax" DOUBLE PRECISION,
    "spent7d" DOUBLE PRECISION,
    "spent3d" DOUBLE PRECISION,
    "roasMax" DOUBLE PRECISION,
    "roas7d" DOUBLE PRECISION,
    "roas3d" DOUBLE PRECISION,
    "ctrMax" DOUBLE PRECISION,
    "purchaseMax" DOUBLE PRECISION,
    "status" "CidStatus",
    "lastUpdatedAt" TIMESTAMP(3),
    "lastPushedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CID_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Creative" (
    "id" TEXT NOT NULL,
    "adId" TEXT,
    "accountId" TEXT,
    "pageId" TEXT,
    "systemPageId" TEXT,
    "postId" TEXT,
    "objectStoryId" TEXT,
    "effectObjectStoryId" TEXT,
    "name" TEXT,
    "creativeType" TEXT,
    "imageHash" TEXT,
    "imageUrl" TEXT,
    "thumbnailUrl" TEXT,
    "previewUrl" TEXT,
    "remoteUpdatedAt" TIMESTAMP(3),
    "lastFetchedAt" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "videoId" TEXT,

    CONSTRAINT "Creative_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdImage" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "hash" TEXT NOT NULL,
    "name" TEXT,
    "url" TEXT,
    "permalink_url" TEXT,
    "width" INTEGER,
    "height" INTEGER,
    "status" TEXT,
    "createdTime" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdImage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdVideo" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "title" TEXT,
    "description" TEXT,
    "status" TEXT,
    "length" INTEGER,
    "thumbnailUrl" TEXT,
    "remoteCreatedAt" TIMESTAMP(3),
    "remoteUpdatedAt" TIMESTAMP(3),
    "lastFetchedAt" TIMESTAMP(3),
    "rawPayload" JSONB,
    "createdTime" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AdVideo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdInsight" (
    "id" TEXT NOT NULL,
    "level" TEXT NOT NULL,
    "adId" TEXT,
    "dateStart" TEXT NOT NULL,
    "dateStop" TEXT NOT NULL,
    "impressions" INTEGER NOT NULL,
    "clicks" INTEGER NOT NULL,
    "uniqueClicks" INTEGER,
    "uniqueCtr" INTEGER,
    "reach" INTEGER,
    "frequency" DOUBLE PRECISION,
    "spend" DOUBLE PRECISION NOT NULL,
    "cpc" DOUBLE PRECISION,
    "cpm" DOUBLE PRECISION,
    "ctr" DOUBLE PRECISION,
    "results" INTEGER,
    "costPerResult" DOUBLE PRECISION,
    "actions" JSONB,
    "actionValues" JSONB,
    "purchaseRoas" JSONB,
    "qualityRanking" TEXT,
    "engagementRateRanking" TEXT,
    "conversionRateRanking" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "rawPayload" JSONB,
    "range" "InsightRange",

    CONSTRAINT "AdInsight_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChangeLog" (
    "id" TEXT NOT NULL,
    "actorId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "targetType" TEXT,
    "targetId" TEXT,
    "diff" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChangeLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TemplateCampaign" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "data" JSONB,
    "reference_id" TEXT,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "TemplateCampaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemCampaign" (
    "id" TEXT NOT NULL,
    "data" JSONB,
    "meta_id" TEXT,
    "cid" TEXT,
    "status" "Status" NOT NULL DEFAULT 'DRAFT',
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "accountId" TEXT,
    "is_template" BOOLEAN DEFAULT false,
    "campaign_name" TEXT,
    "campaign_objective" "CampaignObjective",
    "campaign_budgetType" TEXT,
    "campaign_budget" INTEGER,
    "campaign_bidStrategy" "BidStrategy",
    "campaign_bidAmount" INTEGER,
    "campaign_CBO" BOOLEAN,

    CONSTRAINT "SystemCampaign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemAdSet" (
    "id" TEXT NOT NULL,
    "data" JSONB,
    "meta_id" TEXT,
    "status" "Status" NOT NULL DEFAULT 'DRAFT',
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "campaignId" TEXT,
    "accountId" TEXT,
    "adset_name" TEXT,
    "adset_optimization" TEXT,
    "adset_budgetType" TEXT,
    "adset_budget" INTEGER,
    "adset_bidStrategy" "BidStrategy",
    "adset_bidAmount" INTEGER,

    CONSTRAINT "SystemAdSet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemAd" (
    "id" TEXT NOT NULL,
    "data" JSONB,
    "meta_id" TEXT,
    "status" "Status" NOT NULL DEFAULT 'DRAFT',
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "adSetId" TEXT,
    "accountId" TEXT,

    CONSTRAINT "SystemAd_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemCreative" (
    "id" TEXT NOT NULL,
    "data" JSONB,
    "url_json" JSONB,
    "meta_id" TEXT,
    "status" "Status" NOT NULL DEFAULT 'DRAFT',
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "adId" TEXT,
    "accountId" TEXT,

    CONSTRAINT "SystemCreative_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CidContent_code_name_ma_sanpham_ten_sanpham_project_name_idx" ON "CidContent"("code", "name", "ma_sanpham", "ten_sanpham", "project_name");

-- CreateIndex
CREATE UNIQUE INDEX "CidContent_code_key" ON "CidContent"("code");

-- CreateIndex
CREATE UNIQUE INDEX "CidContent_name_key" ON "CidContent"("name");

-- CreateIndex
CREATE UNIQUE INDEX "DropdownCategory_key_key" ON "DropdownCategory"("key");

-- CreateIndex
CREATE INDEX "DropdownCategory_key_idx" ON "DropdownCategory"("key");

-- CreateIndex
CREATE INDEX "DropdownItem_categoryId_idx" ON "DropdownItem"("categoryId");

-- CreateIndex
CREATE INDEX "DropdownItem_externalId_idx" ON "DropdownItem"("externalId");

-- CreateIndex
CREATE UNIQUE INDEX "DropdownItem_categoryId_value_key" ON "DropdownItem"("categoryId", "value");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "UserFanpage_userId_pageId_idx" ON "UserFanpage"("userId", "pageId");

-- CreateIndex
CREATE INDEX "Account_accountType_idx" ON "Account"("accountType");

-- CreateIndex
CREATE INDEX "Account_needsReauth_idx" ON "Account"("needsReauth");

-- CreateIndex
CREATE INDEX "AccountMember_accountId_idx" ON "AccountMember"("accountId");

-- CreateIndex
CREATE INDEX "AccountMember_userId_idx" ON "AccountMember"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "AccountMember_accountId_userId_key" ON "AccountMember"("accountId", "userId");

-- CreateIndex
CREATE INDEX "Campaign_accountId_idx" ON "Campaign"("accountId");

-- CreateIndex
CREATE INDEX "Campaign_status_idx" ON "Campaign"("status");

-- CreateIndex
CREATE INDEX "Campaign_remoteUpdatedAt_idx" ON "Campaign"("remoteUpdatedAt");

-- CreateIndex
CREATE UNIQUE INDEX "Campaign_id_systemCampaignId_key" ON "Campaign"("id", "systemCampaignId");

-- CreateIndex
CREATE INDEX "AdSet_campaignId_idx" ON "AdSet"("campaignId");

-- CreateIndex
CREATE INDEX "AdSet_accountId_idx" ON "AdSet"("accountId");

-- CreateIndex
CREATE INDEX "AdSet_status_idx" ON "AdSet"("status");

-- CreateIndex
CREATE INDEX "Ad_adsetId_idx" ON "Ad"("adsetId");

-- CreateIndex
CREATE INDEX "Ad_creativeId_idx" ON "Ad"("creativeId");

-- CreateIndex
CREATE INDEX "Ad_accountId_idx" ON "Ad"("accountId");

-- CreateIndex
CREATE INDEX "Ad_status_idx" ON "Ad"("status");

-- CreateIndex
CREATE UNIQUE INDEX "CID_cid_key" ON "CID"("cid");

-- CreateIndex
CREATE INDEX "CID_accountId_idx" ON "CID"("accountId");

-- CreateIndex
CREATE INDEX "CID_status_idx" ON "CID"("status");

-- CreateIndex
CREATE INDEX "CID_cid_idx" ON "CID"("cid");

-- CreateIndex
CREATE INDEX "Creative_accountId_idx" ON "Creative"("accountId");

-- CreateIndex
CREATE INDEX "Creative_imageHash_idx" ON "Creative"("imageHash");

-- CreateIndex
CREATE INDEX "Creative_videoId_idx" ON "Creative"("videoId");

-- CreateIndex
CREATE INDEX "AdImage_accountId_idx" ON "AdImage"("accountId");

-- CreateIndex
CREATE INDEX "AdImage_hash_idx" ON "AdImage"("hash");

-- CreateIndex
CREATE UNIQUE INDEX "AdImage_accountId_hash_id_key" ON "AdImage"("accountId", "hash", "id");

-- CreateIndex
CREATE UNIQUE INDEX "AdImage_hash_key" ON "AdImage"("hash");

-- CreateIndex
CREATE INDEX "AdVideo_status_idx" ON "AdVideo"("status");

-- CreateIndex
CREATE INDEX "AdVideo_accountId_idx" ON "AdVideo"("accountId");

-- CreateIndex
CREATE UNIQUE INDEX "AdInsight_adId_dateStart_dateStop_key" ON "AdInsight"("adId", "dateStart", "dateStop");

-- CreateIndex
CREATE INDEX "ChangeLog_actorId_idx" ON "ChangeLog"("actorId");

-- CreateIndex
CREATE INDEX "ChangeLog_targetType_targetId_idx" ON "ChangeLog"("targetType", "targetId");

-- AddForeignKey
ALTER TABLE "DropdownItem" ADD CONSTRAINT "DropdownItem_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "DropdownCategory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserFanpage" ADD CONSTRAINT "UserFanpage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserFanpage" ADD CONSTRAINT "UserFanpage_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Fanpage"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountMember" ADD CONSTRAINT "AccountMember_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountMember" ADD CONSTRAINT "AccountMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_systemCampaignId_fkey" FOREIGN KEY ("systemCampaignId") REFERENCES "SystemCampaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSet" ADD CONSTRAINT "AdSet_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdSet" ADD CONSTRAINT "AdSet_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_adsetId_fkey" FOREIGN KEY ("adsetId") REFERENCES "AdSet"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_cid_fkey" FOREIGN KEY ("cid") REFERENCES "CID"("cid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_creativeId_fkey" FOREIGN KEY ("creativeId") REFERENCES "Creative"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CID" ADD CONSTRAINT "CID_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_systemPageId_fkey" FOREIGN KEY ("systemPageId") REFERENCES "Fanpage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_imageHash_fkey" FOREIGN KEY ("imageHash") REFERENCES "AdImage"("hash") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_videoId_fkey" FOREIGN KEY ("videoId") REFERENCES "AdVideo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdImage" ADD CONSTRAINT "AdImage_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdVideo" ADD CONSTRAINT "AdVideo_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdInsight" ADD CONSTRAINT "AdInsight_adId_fkey" FOREIGN KEY ("adId") REFERENCES "Ad"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeLog" ADD CONSTRAINT "ChangeLog_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemCampaign" ADD CONSTRAINT "SystemCampaign_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemAdSet" ADD CONSTRAINT "SystemAdSet_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "SystemCampaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemAdSet" ADD CONSTRAINT "SystemAdSet_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemAd" ADD CONSTRAINT "SystemAd_adSetId_fkey" FOREIGN KEY ("adSetId") REFERENCES "SystemAdSet"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemAd" ADD CONSTRAINT "SystemAd_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemCreative" ADD CONSTRAINT "SystemCreative_adId_fkey" FOREIGN KEY ("adId") REFERENCES "SystemAd"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SystemCreative" ADD CONSTRAINT "SystemCreative_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;
