-- AlterTable
ALTER TABLE "AutomationCategory" ADD COLUMN     "projectId" TEXT;

-- CreateIndex
CREATE INDEX "AutomationCategory_projectId_idx" ON "AutomationCategory"("projectId");
