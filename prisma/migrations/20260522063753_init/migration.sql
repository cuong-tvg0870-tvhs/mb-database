-- CreateEnum
CREATE TYPE "ProductCatalogPermission" AS ENUM ('VIEW', 'EDIT', 'ADMIN');

-- CreateTable
CREATE TABLE "UserProductCatalog" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "catalogId" TEXT NOT NULL,
    "permission" "ProductCatalogPermission" NOT NULL DEFAULT 'VIEW',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserProductCatalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectProductCatalog" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "catalogId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProjectProductCatalog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "UserProductCatalog_userId_catalogId_idx" ON "UserProductCatalog"("userId", "catalogId");

-- CreateIndex
CREATE INDEX "ProjectProductCatalog_projectId_idx" ON "ProjectProductCatalog"("projectId");

-- CreateIndex
CREATE INDEX "ProjectProductCatalog_catalogId_idx" ON "ProjectProductCatalog"("catalogId");

-- CreateIndex
CREATE UNIQUE INDEX "ProjectProductCatalog_projectId_catalogId_key" ON "ProjectProductCatalog"("projectId", "catalogId");

-- AddForeignKey
ALTER TABLE "UserProductCatalog" ADD CONSTRAINT "UserProductCatalog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserProductCatalog" ADD CONSTRAINT "UserProductCatalog_catalogId_fkey" FOREIGN KEY ("catalogId") REFERENCES "ProductCatalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectProductCatalog" ADD CONSTRAINT "ProjectProductCatalog_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectProductCatalog" ADD CONSTRAINT "ProjectProductCatalog_catalogId_fkey" FOREIGN KEY ("catalogId") REFERENCES "ProductCatalog"("id") ON DELETE CASCADE ON UPDATE CASCADE;
