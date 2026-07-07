-- AlterTable
ALTER TABLE "AutomationRuleRunItem" ADD COLUMN     "asyncPollAttempts" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "asyncRequestIds" TEXT;
