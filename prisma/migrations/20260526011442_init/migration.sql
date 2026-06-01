-- CreateEnum
CREATE TYPE "AutomationRuleLevel" AS ENUM ('AD_ACCOUNT', 'CAMPAIGN', 'ADSET', 'AD');

-- CreateEnum
CREATE TYPE "AutomationScheduleType" AS ENUM ('INTERVAL', 'SPECIFIC');

-- CreateEnum
CREATE TYPE "AutomationTaskKind" AS ENUM ('START', 'PAUSE', 'DUPLICATE', 'NOTIFY', 'INCREASE_BUDGET', 'DECREASE_BUDGET', 'SET_SPENDING_LIMITS', 'REMOVE_SPENDING_LIMITS', 'INCREASE_SPENDING_LIMITS', 'DECREASE_SPENDING_LIMITS', 'ADD_TO_NAME', 'REMOVE_FROM_NAME', 'REPLACE_TEXT_IN_NAME');

-- CreateEnum
CREATE TYPE "AutomationGroupOperator" AS ENUM ('AND', 'OR');

-- CreateEnum
CREATE TYPE "AutomationCompareType" AS ENUM ('VALUE', 'METRIC', 'RANKING');

-- CreateEnum
CREATE TYPE "AutomationRuleStatus" AS ENUM ('DRAFT', 'ACTIVE', 'PAUSED');

-- CreateEnum
CREATE TYPE "AutomationRuleRunStatus" AS ENUM ('RUNNING', 'COMPLETED', 'FAILED', 'SKIPPED_OVERLAP', 'SKIPPED_OUT_OF_DATE_RANGE');

-- CreateEnum
CREATE TYPE "AutomationRuleRunItemStatus" AS ENUM ('NOT_MATCHED', 'PENDING', 'CONFIRMED', 'REJECTED', 'EXPIRED', 'EXECUTED', 'FAILED', 'SKIPPED');

-- CreateTable
CREATE TABLE "AutomationCategory" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "position" INTEGER NOT NULL DEFAULT 0,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AutomationCategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationFolder" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "position" INTEGER NOT NULL DEFAULT 0,
    "categoryId" TEXT NOT NULL,
    "parentId" TEXT,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AutomationFolder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationRule" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "AutomationRuleStatus" NOT NULL DEFAULT 'DRAFT',
    "level" "AutomationRuleLevel" NOT NULL,
    "timezone" TEXT NOT NULL,
    "notifyErrorsOnly" BOOLEAN NOT NULL DEFAULT false,
    "filterGroupOperator" "AutomationGroupOperator" NOT NULL DEFAULT 'OR',
    "position" INTEGER NOT NULL DEFAULT 0,
    "categoryId" TEXT NOT NULL,
    "folderId" TEXT,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "AutomationRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationRuleAdAccount" (
    "ruleId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,

    CONSTRAINT "AutomationRuleAdAccount_pkey" PRIMARY KEY ("ruleId","accountId")
);

-- CreateTable
CREATE TABLE "AutomationCustomTimeframe" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "fromOffset" INTEGER NOT NULL,
    "toOffset" INTEGER NOT NULL,
    "accountId" TEXT NOT NULL,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AutomationCustomTimeframe_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationRuleNotifyUser" (
    "ruleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "AutomationRuleNotifyUser_pkey" PRIMARY KEY ("ruleId","userId")
);

-- CreateTable
CREATE TABLE "AutomationSchedule" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "type" "AutomationScheduleType" NOT NULL DEFAULT 'INTERVAL',
    "interval" TEXT,
    "specificSlots" JSONB,
    "useDateRange" BOOLEAN NOT NULL DEFAULT false,
    "dateFrom" TIMESTAMP(3),
    "dateTo" TIMESTAMP(3),

    CONSTRAINT "AutomationSchedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationFilterGroup" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "operator" "AutomationGroupOperator" NOT NULL DEFAULT 'AND',
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "AutomationFilterGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationFilter" (
    "id" TEXT NOT NULL,
    "filterGroupId" TEXT NOT NULL,
    "field" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "values" JSONB NOT NULL,
    "timeframe" TEXT,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "AutomationFilter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationTask" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "kind" "AutomationTaskKind" NOT NULL,
    "subtitle" TEXT,
    "params" JSONB,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "AutomationTask_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationTaskGroup" (
    "id" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "rootForTaskId" TEXT,
    "parentGroupId" TEXT,
    "operator" "AutomationGroupOperator" NOT NULL DEFAULT 'AND',
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "AutomationTaskGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationTaskCondition" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "compareType" "AutomationCompareType" NOT NULL DEFAULT 'VALUE',
    "params" JSONB NOT NULL,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "AutomationTaskCondition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationRuleRun" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "scheduledFor" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "status" "AutomationRuleRunStatus" NOT NULL DEFAULT 'RUNNING',
    "entitiesScanned" INTEGER NOT NULL DEFAULT 0,
    "matchedCount" INTEGER NOT NULL DEFAULT 0,
    "errorsCount" INTEGER NOT NULL DEFAULT 0,
    "errorMessage" TEXT,
    "ruleSnapshot" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AutomationRuleRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AutomationRuleRunItem" (
    "id" TEXT NOT NULL,
    "runId" TEXT NOT NULL,
    "taskId" TEXT,
    "taskKind" "AutomationTaskKind",
    "level" "AutomationRuleLevel" NOT NULL,
    "entityId" TEXT NOT NULL,
    "entityName" TEXT NOT NULL,
    "parentLabel" TEXT,
    "status" "AutomationRuleRunItemStatus" NOT NULL DEFAULT 'PENDING',
    "snapshot" JSONB NOT NULL,
    "changePreview" JSONB NOT NULL,
    "evaluation" JSONB,
    "matchedConditionSummary" TEXT,
    "confirmedAt" TIMESTAMP(3),
    "confirmedById" TEXT,
    "executedAt" TIMESTAMP(3),
    "errorMessage" TEXT,
    "executionAttempts" INTEGER NOT NULL DEFAULT 0,
    "executionError" JSONB,
    "metaTraceId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AutomationRuleRunItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AutomationCategory_createdById_position_idx" ON "AutomationCategory"("createdById", "position");

-- CreateIndex
CREATE INDEX "AutomationFolder_categoryId_parentId_position_idx" ON "AutomationFolder"("categoryId", "parentId", "position");

-- CreateIndex
CREATE INDEX "AutomationFolder_parentId_idx" ON "AutomationFolder"("parentId");

-- CreateIndex
CREATE INDEX "AutomationRule_categoryId_folderId_position_idx" ON "AutomationRule"("categoryId", "folderId", "position");

-- CreateIndex
CREATE INDEX "AutomationRule_createdById_updatedAt_idx" ON "AutomationRule"("createdById", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AutomationRule_status_updatedAt_idx" ON "AutomationRule"("status", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "AutomationRuleAdAccount_accountId_idx" ON "AutomationRuleAdAccount"("accountId");

-- CreateIndex
CREATE INDEX "AutomationCustomTimeframe_accountId_idx" ON "AutomationCustomTimeframe"("accountId");

-- CreateIndex
CREATE INDEX "AutomationRuleNotifyUser_userId_idx" ON "AutomationRuleNotifyUser"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "AutomationSchedule_ruleId_key" ON "AutomationSchedule"("ruleId");

-- CreateIndex
CREATE INDEX "AutomationFilterGroup_ruleId_position_idx" ON "AutomationFilterGroup"("ruleId", "position");

-- CreateIndex
CREATE INDEX "AutomationFilter_filterGroupId_position_idx" ON "AutomationFilter"("filterGroupId", "position");

-- CreateIndex
CREATE INDEX "AutomationTask_ruleId_position_idx" ON "AutomationTask"("ruleId", "position");

-- CreateIndex
CREATE UNIQUE INDEX "AutomationTaskGroup_rootForTaskId_key" ON "AutomationTaskGroup"("rootForTaskId");

-- CreateIndex
CREATE INDEX "AutomationTaskGroup_taskId_parentGroupId_position_idx" ON "AutomationTaskGroup"("taskId", "parentGroupId", "position");

-- CreateIndex
CREATE INDEX "AutomationTaskCondition_groupId_position_idx" ON "AutomationTaskCondition"("groupId", "position");

-- CreateIndex
CREATE INDEX "AutomationRuleRun_ruleId_scheduledFor_idx" ON "AutomationRuleRun"("ruleId", "scheduledFor" DESC);

-- CreateIndex
CREATE INDEX "AutomationRuleRun_accountId_scheduledFor_idx" ON "AutomationRuleRun"("accountId", "scheduledFor" DESC);

-- CreateIndex
CREATE INDEX "AutomationRuleRun_status_scheduledFor_idx" ON "AutomationRuleRun"("status", "scheduledFor" DESC);

-- CreateIndex
CREATE INDEX "AutomationRuleRunItem_runId_idx" ON "AutomationRuleRunItem"("runId");

-- CreateIndex
CREATE INDEX "AutomationRuleRunItem_entityId_idx" ON "AutomationRuleRunItem"("entityId");

-- CreateIndex
CREATE INDEX "AutomationRuleRunItem_taskId_idx" ON "AutomationRuleRunItem"("taskId");

-- CreateIndex
CREATE INDEX "AutomationRuleRunItem_status_createdAt_idx" ON "AutomationRuleRunItem"("status", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "AutomationFolder" ADD CONSTRAINT "AutomationFolder_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "AutomationCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationFolder" ADD CONSTRAINT "AutomationFolder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "AutomationFolder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRule" ADD CONSTRAINT "AutomationRule_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "AutomationCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRule" ADD CONSTRAINT "AutomationRule_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "AutomationFolder"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRuleAdAccount" ADD CONSTRAINT "AutomationRuleAdAccount_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "AutomationRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRuleNotifyUser" ADD CONSTRAINT "AutomationRuleNotifyUser_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "AutomationRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationSchedule" ADD CONSTRAINT "AutomationSchedule_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "AutomationRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationFilterGroup" ADD CONSTRAINT "AutomationFilterGroup_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "AutomationRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationFilter" ADD CONSTRAINT "AutomationFilter_filterGroupId_fkey" FOREIGN KEY ("filterGroupId") REFERENCES "AutomationFilterGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationTask" ADD CONSTRAINT "AutomationTask_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "AutomationRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationTaskGroup" ADD CONSTRAINT "AutomationTaskGroup_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "AutomationTask"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationTaskGroup" ADD CONSTRAINT "AutomationTaskGroup_rootForTaskId_fkey" FOREIGN KEY ("rootForTaskId") REFERENCES "AutomationTask"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationTaskGroup" ADD CONSTRAINT "AutomationTaskGroup_parentGroupId_fkey" FOREIGN KEY ("parentGroupId") REFERENCES "AutomationTaskGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationTaskCondition" ADD CONSTRAINT "AutomationTaskCondition_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "AutomationTaskGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRuleRun" ADD CONSTRAINT "AutomationRuleRun_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "AutomationRule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRuleRunItem" ADD CONSTRAINT "AutomationRuleRunItem_runId_fkey" FOREIGN KEY ("runId") REFERENCES "AutomationRuleRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AutomationRuleRunItem" ADD CONSTRAINT "AutomationRuleRunItem_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "AutomationTask"("id") ON DELETE SET NULL ON UPDATE CASCADE;
