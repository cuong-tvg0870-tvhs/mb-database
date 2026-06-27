-- AlterTable
ALTER TABLE "MessageTemplate" ADD COLUMN     "createdById" TEXT;

-- CreateIndex
CREATE INDEX "MessageTemplate_createdById_idx" ON "MessageTemplate"("createdById");

-- AddForeignKey
ALTER TABLE "MessageTemplate" ADD CONSTRAINT "MessageTemplate_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
