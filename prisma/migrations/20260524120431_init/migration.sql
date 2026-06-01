-- CreateTable
CREATE TABLE "CreativeAssetMapping" (
    "id" TEXT NOT NULL,
    "creativeId" TEXT NOT NULL,
    "creativeAssetId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CreativeAssetMapping_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CreativeAssetMapping_creativeAssetId_idx" ON "CreativeAssetMapping"("creativeAssetId");

-- CreateIndex
CREATE INDEX "CreativeAssetMapping_creativeId_idx" ON "CreativeAssetMapping"("creativeId");

-- CreateIndex
CREATE UNIQUE INDEX "CreativeAssetMapping_creativeId_creativeAssetId_key" ON "CreativeAssetMapping"("creativeId", "creativeAssetId");

-- AddForeignKey
ALTER TABLE "CreativeAssetMapping" ADD CONSTRAINT "CreativeAssetMapping_creativeId_fkey" FOREIGN KEY ("creativeId") REFERENCES "Creative"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreativeAssetMapping" ADD CONSTRAINT "CreativeAssetMapping_creativeAssetId_fkey" FOREIGN KEY ("creativeAssetId") REFERENCES "CreativeAsset"("id") ON DELETE CASCADE ON UPDATE CASCADE;
