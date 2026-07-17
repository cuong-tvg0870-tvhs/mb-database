-- AlterTable
ALTER TABLE "AutomationInsightBackfillState" ADD COLUMN     "lastRecentRefreshAt" TIMESTAMP(3),
ADD COLUMN     "recentThroughDate" TEXT;
