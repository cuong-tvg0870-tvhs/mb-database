-- Migration: auto_launch_rule — "Quy tắc tự lên Camp"
--
-- Ý nghĩa: gom đủ N creative đạt chuẩn (organic valid-post) → tự lên 1 chiến dịch từ
-- mẫu; hoặc để nháp, hoặc tự đăng lên Meta. Điều kiện + lịch dùng chung shape rule-builder
-- (config = { tasks }, schedule JSON). Nhật ký chạy như Care Ads.
--
-- ADDITIVE / NON-BREAKING: chỉ THÊM 2 enum + 2 bảng mới, không đụng bảng đang chạy →
-- an toàn với 2 writer (mb-ads + mb-batch). Tái dùng enum "DraftAutomationPublishMode"
-- đã có sẵn (KHÔNG tạo lại).
--
-- Rollout: chạy migration này TRƯỚC khi deploy mb-ads (module CRUD) và mb-batch (runner).

-- CreateEnum
CREATE TYPE "AutoLaunchRuleStatus" AS ENUM ('ACTIVE', 'PAUSED');

-- CreateEnum
CREATE TYPE "AutoLaunchRunStatus" AS ENUM ('LAUNCHED', 'SKIPPED_NOT_ENOUGH', 'SKIPPED_DAILY_CAP', 'SKIPPED_NO_NEW', 'FAILED');

-- CreateTable
CREATE TABLE "auto_launch_rule" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "AutoLaunchRuleStatus" NOT NULL DEFAULT 'ACTIVE',
    "accountIds" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "config" JSONB NOT NULL,
    "schedule" JSONB NOT NULL,
    "templateId" TEXT NOT NULL,
    "minQualifying" INTEGER NOT NULL DEFAULT 5,
    "publishMode" "DraftAutomationPublishMode" NOT NULL DEFAULT 'DRAFT_ONLY',
    "maxCampaignsPerDay" INTEGER NOT NULL DEFAULT 2,
    "budgetCapPerCampaign" INTEGER,
    "launchedCount" INTEGER NOT NULL DEFAULT 0,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "auto_launch_rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auto_launch_rule_run" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "scheduledFor" TIMESTAMP(3) NOT NULL,
    "status" "AutoLaunchRunStatus" NOT NULL,
    "scanned" INTEGER NOT NULL DEFAULT 0,
    "qualified" INTEGER NOT NULL DEFAULT 0,
    "message" TEXT,
    "usedCreatives" JSONB,
    "generatedCampaignId" TEXT,
    "metaId" TEXT,
    "mode" "DraftAutomationPublishMode",
    "dedupeKey" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "auto_launch_rule_run_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "auto_launch_rule_status_updatedAt_idx" ON "auto_launch_rule"("status", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "auto_launch_rule_createdById_updatedAt_idx" ON "auto_launch_rule"("createdById", "updatedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "auto_launch_rule_run_dedupeKey_key" ON "auto_launch_rule_run"("dedupeKey");

-- CreateIndex
CREATE INDEX "auto_launch_rule_run_ruleId_createdAt_idx" ON "auto_launch_rule_run"("ruleId", "createdAt" DESC);

-- AddForeignKey
ALTER TABLE "auto_launch_rule_run" ADD CONSTRAINT "auto_launch_rule_run_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "auto_launch_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;
