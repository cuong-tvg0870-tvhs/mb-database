-- Phase 3: per-account Meta usage telemetry + lastEvaluatedAt on backfill state.
-- Idempotent (IF NOT EXISTS) — safe to re-apply on a drifted database.

-- AlterTable: track when an active rule/warmer last confirmed a backfill state is in use.
ALTER TABLE "AutomationInsightBackfillState" ADD COLUMN IF NOT EXISTS "lastEvaluatedAt" TIMESTAMP(3);

-- CreateTable: latest Meta rate-limit usage per (scope, bucket).
CREATE TABLE IF NOT EXISTS "AutomationMetaUsage" (
    "id" TEXT NOT NULL,
    "scope" TEXT NOT NULL,
    "bucket" TEXT NOT NULL,
    "maxPct" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "regainSec" INTEGER NOT NULL DEFAULT 0,
    "tier" TEXT,
    "observedAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "AutomationMetaUsage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "AutomationMetaUsage_scope_bucket_key" ON "AutomationMetaUsage"("scope", "bucket");
CREATE INDEX IF NOT EXISTS "AutomationMetaUsage_scope_idx" ON "AutomationMetaUsage"("scope");
