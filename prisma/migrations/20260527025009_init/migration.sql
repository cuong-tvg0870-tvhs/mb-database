-- CreateEnum
CREATE TYPE "MetaConnectionStatus" AS ENUM ('ACTIVE', 'REVOKED', 'INVALID');

-- AlterTable
ALTER TABLE "Account" ADD COLUMN     "metaConnectionId" TEXT;

-- CreateTable
CREATE TABLE "MetaConnection" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "encryptedAccessToken" TEXT NOT NULL,
    "tokenType" TEXT NOT NULL DEFAULT 'SYSTEM_USER',
    "fbUserId" TEXT,
    "fbBusinessId" TEXT,
    "scopes" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "status" "MetaConnectionStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastVerifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MetaConnection_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MetaConnection_userId_key" ON "MetaConnection"("userId");

-- CreateIndex
CREATE INDEX "MetaConnection_status_idx" ON "MetaConnection"("status");

-- CreateIndex
CREATE INDEX "Account_metaConnectionId_idx" ON "Account"("metaConnectionId");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_metaConnectionId_fkey" FOREIGN KEY ("metaConnectionId") REFERENCES "MetaConnection"("id") ON DELETE SET NULL ON UPDATE CASCADE;
