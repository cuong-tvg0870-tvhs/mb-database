-- CreateTable
CREATE TABLE "ProductCatalog" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "fallbackImageUrl" TEXT,
    "businessId" TEXT,
    "accountId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductCatalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductSet" (
    "id" TEXT NOT NULL,
    "catalogId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "filter" JSONB,
    "productCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductSet_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ProductCatalog_businessId_idx" ON "ProductCatalog"("businessId");

-- CreateIndex
CREATE INDEX "ProductCatalog_accountId_idx" ON "ProductCatalog"("accountId");

-- CreateIndex
CREATE INDEX "ProductSet_catalogId_idx" ON "ProductSet"("catalogId");

-- AddForeignKey
ALTER TABLE "ProductSet" ADD CONSTRAINT "ProductSet_catalogId_fkey" FOREIGN KEY ("catalogId") REFERENCES "ProductCatalog"("id") ON DELETE CASCADE ON UPDATE CASCADE;
