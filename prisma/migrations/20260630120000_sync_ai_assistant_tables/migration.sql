-- Baseline migration: these objects already exist on the shared production DB
-- (created out-of-band by the mb-ads AI assistant service). This migration is
-- marked as already-applied via `prisma migrate resolve --applied`, so the SQL
-- below only runs when provisioning a fresh database. Guards make it idempotent.

-- AlterTable
ALTER TABLE "HelpChatSession" ADD COLUMN IF NOT EXISTS "mode" TEXT NOT NULL DEFAULT 'docs';

-- CreateTable
CREATE TABLE IF NOT EXISTS "AiPendingAction" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "targetType" TEXT NOT NULL,
    "targetIds" JSONB NOT NULL,
    "params" JSONB,
    "summary" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PROPOSED',
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AiPendingAction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "AiActionLog" (
    "id" TEXT NOT NULL,
    "pendingActionId" TEXT,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "targetId" TEXT NOT NULL,
    "before" JSONB,
    "params" JSONB,
    "status" TEXT NOT NULL,
    "errorMessage" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AiActionLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AiPendingAction_userId_status_idx" ON "AiPendingAction"("userId", "status");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "AiActionLog_userId_createdAt_idx" ON "AiActionLog"("userId", "createdAt");
