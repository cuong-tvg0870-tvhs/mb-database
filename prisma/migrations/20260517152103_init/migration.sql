-- CreateEnum
CREATE TYPE "ProjectRole" AS ENUM ('MANAGER', 'MEMBER');

-- CreateEnum
CREATE TYPE "FolderPermission" AS ENUM ('VIEW', 'EDIT');

-- CreateTable
CREATE TABLE "Project" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectMember" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "ProjectRole" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProjectMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectAccount" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProjectAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectFanpage" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProjectFanpage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectFolder" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "folderId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProjectFolder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FolderMember" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "folderId" TEXT NOT NULL,
    "permission" "FolderPermission" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FolderMember_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ProjectMember_projectId_idx" ON "ProjectMember"("projectId");

-- CreateIndex
CREATE INDEX "ProjectMember_userId_idx" ON "ProjectMember"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectMember_projectId_userId_key" ON "ProjectMember"("projectId", "userId");

-- CreateIndex
CREATE INDEX "ProjectAccount_projectId_idx" ON "ProjectAccount"("projectId");

-- CreateIndex
CREATE INDEX "ProjectAccount_accountId_idx" ON "ProjectAccount"("accountId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectAccount_projectId_accountId_key" ON "ProjectAccount"("projectId", "accountId");

-- CreateIndex
CREATE INDEX "ProjectFanpage_projectId_idx" ON "ProjectFanpage"("projectId");

-- CreateIndex
CREATE INDEX "ProjectFanpage_pageId_idx" ON "ProjectFanpage"("pageId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectFanpage_projectId_pageId_key" ON "ProjectFanpage"("projectId", "pageId");

-- CreateIndex
CREATE INDEX "ProjectFolder_projectId_idx" ON "ProjectFolder"("projectId");

-- CreateIndex
CREATE INDEX "ProjectFolder_folderId_idx" ON "ProjectFolder"("folderId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectFolder_projectId_folderId_key" ON "ProjectFolder"("projectId", "folderId");

-- CreateIndex
CREATE INDEX "FolderMember_userId_idx" ON "FolderMember"("userId");

-- CreateIndex
CREATE INDEX "FolderMember_folderId_idx" ON "FolderMember"("folderId");

-- CreateIndex
CREATE UNIQUE INDEX "FolderMember_userId_folderId_key" ON "FolderMember"("userId", "folderId");

-- AddForeignKey
ALTER TABLE "ProjectMember" ADD CONSTRAINT "ProjectMember_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectMember" ADD CONSTRAINT "ProjectMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectAccount" ADD CONSTRAINT "ProjectAccount_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectAccount" ADD CONSTRAINT "ProjectAccount_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectFanpage" ADD CONSTRAINT "ProjectFanpage_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectFanpage" ADD CONSTRAINT "ProjectFanpage_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Fanpage"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectFolder" ADD CONSTRAINT "ProjectFolder_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FolderMember" ADD CONSTRAINT "FolderMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
