-- CreateEnum
CREATE TYPE "ProposalStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateTable
CREATE TABLE "AccountProposal" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "targetUserEmail" TEXT NOT NULL,
    "targetUserName" TEXT NOT NULL,
    "employeeId" TEXT,
    "rank" TEXT,
    "project" TEXT,
    "adAccounts" JSONB,
    "fanpages" JSONB,
    "pixels" JSONB,
    "bms" JSONB,
    "status" "ProposalStatus" NOT NULL DEFAULT 'PENDING',
    "checkResult" JSONB,
    "adminFeedback" TEXT,
    "processedById" TEXT,
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AccountProposal_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AccountProposal_userId_idx" ON "AccountProposal"("userId");

-- CreateIndex
CREATE INDEX "AccountProposal_status_idx" ON "AccountProposal"("status");

-- AddForeignKey
ALTER TABLE "AccountProposal" ADD CONSTRAINT "AccountProposal_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountProposal" ADD CONSTRAINT "AccountProposal_processedById_fkey" FOREIGN KEY ("processedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
