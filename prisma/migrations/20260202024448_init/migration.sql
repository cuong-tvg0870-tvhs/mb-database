-- CreateEnum
CREATE TYPE "PlanningType" AS ENUM ('SYNC_CAMPAIGN', 'SYNC_INSIGHT', 'RULE_CAMPAIGN');

-- CreateEnum
CREATE TYPE "PlanningStatus" AS ENUM ('IDLE', 'RUNNING', 'FAILED');

-- CreateTable
CREATE TABLE "Planning" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "PlanningType" NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "intervalSec" INTEGER NOT NULL,
    "lastRunAt" TIMESTAMP(3),
    "nextRunAt" TIMESTAMP(3) NOT NULL,
    "payload" JSONB NOT NULL,
    "status" "PlanningStatus" NOT NULL DEFAULT 'IDLE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Planning_pkey" PRIMARY KEY ("id")
);
