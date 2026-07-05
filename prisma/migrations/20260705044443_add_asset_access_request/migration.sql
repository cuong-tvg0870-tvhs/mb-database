-- CreateEnum
CREATE TYPE "AssetAccessType" AS ENUM ('AD_ACCOUNT', 'FANPAGE', 'PIXEL', 'CATALOG', 'FOLDER');

-- CreateEnum
CREATE TYPE "AssetAccessRequestStatus" AS ENUM ('DRAFT', 'SUBMITTED', 'GRANTING_ON_META', 'DONE', 'PARTIAL', 'NEED_MORE_INFO', 'CANNOT_GRANT');

-- CreateEnum
CREATE TYPE "AssetItemStatus" AS ENUM ('PENDING', 'FETCHED', 'ALLOCATED', 'FAILED', 'SKIPPED');

-- CreateTable
CREATE TABLE "AssetAccessRequest" (
    "id" TEXT NOT NULL,
    "requesterId" TEXT NOT NULL,
    "assigneeUserId" TEXT,
    "assigneeEmail" TEXT,
    "assigneeName" TEXT,
    "employeeId" TEXT,
    "projectId" TEXT,
    "businessId" TEXT,
    "note" TEXT,
    "status" "AssetAccessRequestStatus" NOT NULL DEFAULT 'SUBMITTED',
    "adminFeedback" TEXT,
    "processedById" TEXT,
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AssetAccessRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssetAccessRequestItem" (
    "id" TEXT NOT NULL,
    "requestId" TEXT NOT NULL,
    "type" "AssetType" NOT NULL,
    "metaId" TEXT NOT NULL,
    "name" TEXT,
    "status" "AssetItemStatus" NOT NULL DEFAULT 'PENDING',
    "fetchError" TEXT,
    "fetchedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AssetAccessRequestItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "AssetAccessRequest_requesterId_idx" ON "AssetAccessRequest"("requesterId");

-- CreateIndex
CREATE INDEX "AssetAccessRequest_assigneeUserId_idx" ON "AssetAccessRequest"("assigneeUserId");

-- CreateIndex
CREATE INDEX "AssetAccessRequest_projectId_idx" ON "AssetAccessRequest"("projectId");

-- CreateIndex
CREATE INDEX "AssetAccessRequest_status_idx" ON "AssetAccessRequest"("status");

-- CreateIndex
CREATE INDEX "AssetAccessRequestItem_requestId_idx" ON "AssetAccessRequestItem"("requestId");

-- CreateIndex
CREATE INDEX "AssetAccessRequestItem_type_metaId_idx" ON "AssetAccessRequestItem"("type", "metaId");

-- AddForeignKey
ALTER TABLE "AssetAccessRequest" ADD CONSTRAINT "AssetAccessRequest_requesterId_fkey" FOREIGN KEY ("requesterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetAccessRequest" ADD CONSTRAINT "AssetAccessRequest_assigneeUserId_fkey" FOREIGN KEY ("assigneeUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetAccessRequest" ADD CONSTRAINT "AssetAccessRequest_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetAccessRequest" ADD CONSTRAINT "AssetAccessRequest_processedById_fkey" FOREIGN KEY ("processedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetAccessRequestItem" ADD CONSTRAINT "AssetAccessRequestItem_requestId_fkey" FOREIGN KEY ("requestId") REFERENCES "AssetAccessRequest"("id") ON DELETE CASCADE ON UPDATE CASCADE;
