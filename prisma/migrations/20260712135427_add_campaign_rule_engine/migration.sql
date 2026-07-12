-- Campaign Rule Engine (MB-owned) — cụm bảng RIÊNG campaign_rule_* + enum RIÊNG CampaignRule*.
-- Bối cảnh: mb-* dùng CHUNG Postgres (schema public) với Care Ads; Automation* là của
-- Care Ads đang chạy live. Cụm này TÁCH hẳn (bảng campaign_rule_ + enum CampaignRule*) để
-- MB tự sở hữu rule scheduling mở trong campaign detail, KHÔNG đụng dữ liệu/enum/runner
-- Care Ads. Thuần ADDITIVE (CREATE TYPE/TABLE mới) → an toàn back-compat.

-- CreateEnum
CREATE TYPE "CampaignRuleStatus" AS ENUM ('DRAFT', 'ACTIVE', 'PAUSED');

-- CreateEnum
CREATE TYPE "CampaignRuleLevel" AS ENUM ('AD_ACCOUNT', 'CAMPAIGN', 'ADSET', 'AD');

-- CreateEnum
CREATE TYPE "CampaignRuleScheduleType" AS ENUM ('INTERVAL', 'SPECIFIC');

-- CreateEnum
CREATE TYPE "CampaignRuleGroupOperator" AS ENUM ('AND', 'OR');

-- CreateEnum
CREATE TYPE "CampaignRuleCompareType" AS ENUM ('VALUE', 'METRIC', 'RANKING', 'TIME');

-- CreateEnum
CREATE TYPE "CampaignRuleTaskKind" AS ENUM ('START', 'PAUSE', 'DUPLICATE', 'NOTIFY', 'INCREASE_BUDGET', 'DECREASE_BUDGET', 'SET_SPENDING_LIMITS', 'REMOVE_SPENDING_LIMITS', 'INCREASE_SPENDING_LIMITS', 'DECREASE_SPENDING_LIMITS', 'ADD_TO_NAME', 'REMOVE_FROM_NAME', 'REPLACE_TEXT_IN_NAME', 'BUDGET_SCHEDULE_BUMP', 'LAUNCH_FROM_TEMPLATE');

-- CreateEnum
CREATE TYPE "CampaignRuleRunStatus" AS ENUM ('RUNNING', 'COMPLETED', 'FAILED', 'SKIPPED_OVERLAP', 'SKIPPED_OUT_OF_DATE_RANGE');

-- CreateEnum
CREATE TYPE "CampaignRuleRunItemStatus" AS ENUM ('NOT_MATCHED', 'PENDING', 'CONFIRMED', 'REJECTED', 'EXPIRED', 'EXECUTED', 'FAILED', 'SKIPPED');

-- CreateTable
CREATE TABLE "campaign_rule" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "CampaignRuleStatus" NOT NULL DEFAULT 'DRAFT',
    "level" "CampaignRuleLevel" NOT NULL,
    "accountId" TEXT NOT NULL,
    "campaignId" TEXT,
    "timezone" TEXT NOT NULL,
    "notifyErrorsOnly" BOOLEAN NOT NULL DEFAULT false,
    "filterGroupOperator" "CampaignRuleGroupOperator" NOT NULL DEFAULT 'OR',
    "position" INTEGER NOT NULL DEFAULT 0,
    "useAdSetAttributionWindow" BOOLEAN NOT NULL DEFAULT true,
    "attributionWindow" TEXT,
    "autoExecute" BOOLEAN NOT NULL DEFAULT false,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "campaign_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_schedule" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "type" "CampaignRuleScheduleType" NOT NULL DEFAULT 'INTERVAL',
    "interval" TEXT,
    "specificSlots" JSONB,
    "useDateRange" BOOLEAN NOT NULL DEFAULT false,
    "dateFrom" TIMESTAMP(3),
    "dateTo" TIMESTAMP(3),

    CONSTRAINT "campaign_rule_schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_filter_group" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "operator" "CampaignRuleGroupOperator" NOT NULL DEFAULT 'AND',
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "campaign_rule_filter_group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_filter" (
    "id" TEXT NOT NULL,
    "filterGroupId" TEXT NOT NULL,
    "field" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "values" JSONB NOT NULL,
    "timeframe" TEXT,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "campaign_rule_filter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_task" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "kind" "CampaignRuleTaskKind" NOT NULL,
    "subtitle" TEXT,
    "description" TEXT,
    "params" JSONB,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "campaign_rule_task_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_task_group" (
    "id" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "rootForTaskId" TEXT,
    "parentGroupId" TEXT,
    "operator" "CampaignRuleGroupOperator" NOT NULL DEFAULT 'AND',
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "campaign_rule_task_group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_task_condition" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "compareType" "CampaignRuleCompareType" NOT NULL DEFAULT 'VALUE',
    "params" JSONB NOT NULL,
    "position" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "campaign_rule_task_condition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_run" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "scheduledFor" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "finishedAt" TIMESTAMP(3),
    "dedupeKey" TEXT,
    "status" "CampaignRuleRunStatus" NOT NULL DEFAULT 'RUNNING',
    "entitiesScanned" INTEGER NOT NULL DEFAULT 0,
    "matchedCount" INTEGER NOT NULL DEFAULT 0,
    "errorsCount" INTEGER NOT NULL DEFAULT 0,
    "errorMessage" TEXT,
    "ruleSnapshot" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "campaign_rule_run_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_rule_run_item" (
    "id" TEXT NOT NULL,
    "runId" TEXT NOT NULL,
    "taskId" TEXT,
    "taskKind" "CampaignRuleTaskKind",
    "level" "CampaignRuleLevel" NOT NULL,
    "entityId" TEXT NOT NULL,
    "entityName" TEXT NOT NULL,
    "parentLabel" TEXT,
    "status" "CampaignRuleRunItemStatus" NOT NULL DEFAULT 'PENDING',
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
    "asyncRequestIds" TEXT,
    "asyncPollAttempts" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaign_rule_run_item_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "campaign_rule_campaignId_status_idx" ON "campaign_rule"("campaignId", "status");

-- CreateIndex
CREATE INDEX "campaign_rule_accountId_updatedAt_idx" ON "campaign_rule"("accountId", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "campaign_rule_createdById_updatedAt_idx" ON "campaign_rule"("createdById", "updatedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "campaign_rule_schedule_ruleId_key" ON "campaign_rule_schedule"("ruleId");

-- CreateIndex
CREATE INDEX "campaign_rule_filter_group_ruleId_position_idx" ON "campaign_rule_filter_group"("ruleId", "position");

-- CreateIndex
CREATE INDEX "campaign_rule_filter_filterGroupId_position_idx" ON "campaign_rule_filter"("filterGroupId", "position");

-- CreateIndex
CREATE INDEX "campaign_rule_task_ruleId_position_idx" ON "campaign_rule_task"("ruleId", "position");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_rule_task_group_rootForTaskId_key" ON "campaign_rule_task_group"("rootForTaskId");

-- CreateIndex
CREATE INDEX "campaign_rule_task_group_taskId_parentGroupId_position_idx" ON "campaign_rule_task_group"("taskId", "parentGroupId", "position");

-- CreateIndex
CREATE INDEX "campaign_rule_task_condition_groupId_position_idx" ON "campaign_rule_task_condition"("groupId", "position");

-- CreateIndex
CREATE INDEX "campaign_rule_run_ruleId_scheduledFor_idx" ON "campaign_rule_run"("ruleId", "scheduledFor" DESC);

-- CreateIndex
CREATE INDEX "campaign_rule_run_accountId_scheduledFor_idx" ON "campaign_rule_run"("accountId", "scheduledFor" DESC);

-- CreateIndex
CREATE INDEX "campaign_rule_run_status_scheduledFor_idx" ON "campaign_rule_run"("status", "scheduledFor" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "campaign_rule_run_dedupeKey_key" ON "campaign_rule_run"("dedupeKey");

-- CreateIndex
CREATE INDEX "campaign_rule_run_item_runId_idx" ON "campaign_rule_run_item"("runId");

-- CreateIndex
CREATE INDEX "campaign_rule_run_item_entityId_idx" ON "campaign_rule_run_item"("entityId");

-- CreateIndex
CREATE INDEX "campaign_rule_run_item_taskId_idx" ON "campaign_rule_run_item"("taskId");

-- CreateIndex
CREATE INDEX "campaign_rule_run_item_status_createdAt_idx" ON "campaign_rule_run_item"("status", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "campaign_rule_schedule" ADD CONSTRAINT "campaign_rule_schedule_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "campaign_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_filter_group" ADD CONSTRAINT "campaign_rule_filter_group_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "campaign_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_filter" ADD CONSTRAINT "campaign_rule_filter_filterGroupId_fkey" FOREIGN KEY ("filterGroupId") REFERENCES "campaign_rule_filter_group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_task" ADD CONSTRAINT "campaign_rule_task_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "campaign_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_task_group" ADD CONSTRAINT "campaign_rule_task_group_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "campaign_rule_task"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_task_group" ADD CONSTRAINT "campaign_rule_task_group_rootForTaskId_fkey" FOREIGN KEY ("rootForTaskId") REFERENCES "campaign_rule_task"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_task_group" ADD CONSTRAINT "campaign_rule_task_group_parentGroupId_fkey" FOREIGN KEY ("parentGroupId") REFERENCES "campaign_rule_task_group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_task_condition" ADD CONSTRAINT "campaign_rule_task_condition_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "campaign_rule_task_group"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_run" ADD CONSTRAINT "campaign_rule_run_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "campaign_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_run_item" ADD CONSTRAINT "campaign_rule_run_item_runId_fkey" FOREIGN KEY ("runId") REFERENCES "campaign_rule_run"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_rule_run_item" ADD CONSTRAINT "campaign_rule_run_item_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "campaign_rule_task"("id") ON DELETE SET NULL ON UPDATE CASCADE;

