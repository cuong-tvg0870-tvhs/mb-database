-- CreateTable
CREATE TABLE "ProductFeed" (
    "id" TEXT NOT NULL,
    "catalogId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "country" TEXT,
    "schedule" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductFeed_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ProductFeed_catalogId_idx" ON "ProductFeed"("catalogId");

-- AddForeignKey
ALTER TABLE "ProductFeed" ADD CONSTRAINT "ProductFeed_catalogId_fkey" FOREIGN KEY ("catalogId") REFERENCES "ProductCatalog"("id") ON DELETE CASCADE ON UPDATE CASCADE;
