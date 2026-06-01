/*
  Warnings:

  - You are about to drop the column `accountId` on the `AutomationCustomTimeframe` table. All the data in the column will be lost.
  - Added the required column `categoryId` to the `AutomationCustomTimeframe` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "CustomMetricScope" AS ENUM ('GLOBAL', 'AD_ACCOUNT', 'CATEGORY');

-- CreateEnum
CREATE TYPE "CustomMetricFormat" AS ENUM ('numeric', 'currency', 'percentage');

-- DropIndex
DROP INDEX "AutomationCustomTimeframe_accountId_idx";

-- AlterTable
ALTER TABLE "AutomationCustomTimeframe" DROP COLUMN "accountId",
ADD COLUMN     "categoryId" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "custom_metrics" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "format" "CustomMetricFormat" NOT NULL DEFAULT 'numeric',
    "scope" "CustomMetricScope" NOT NULL,
    "formula" JSONB NOT NULL,
    "accountId" TEXT,
    "categoryId" TEXT,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "custom_metrics_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "custom_metrics_accountId_idx" ON "custom_metrics"("accountId");

-- CreateIndex
CREATE INDEX "custom_metrics_categoryId_idx" ON "custom_metrics"("categoryId");

-- CreateIndex
CREATE INDEX "custom_metrics_scope_idx" ON "custom_metrics"("scope");

-- CreateIndex
CREATE INDEX "AutomationCustomTimeframe_categoryId_idx" ON "AutomationCustomTimeframe"("categoryId");

-- AddForeignKey
ALTER TABLE "AutomationCustomTimeframe" ADD CONSTRAINT "AutomationCustomTimeframe_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "AutomationCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custom_metrics" ADD CONSTRAINT "custom_metrics_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "AutomationCategory"("id") ON DELETE SET NULL ON UPDATE CASCADE;
