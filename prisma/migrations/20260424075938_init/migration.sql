-- CreateTable
CREATE TABLE "LarkRecord" (
    "id" TEXT NOT NULL,
    "raw" JSONB NOT NULL,
    "cid" TEXT,
    "project_name" TEXT,
    "project_code" TEXT,
    "brand_name" TEXT,
    "brand_code" TEXT,
    "product_code" TEXT,
    "product_name" TEXT,
    "employee_id" TEXT,
    "employee_name" TEXT,
    "drive_url" TEXT,
    "drive_permission" BOOLEAN,
    "creative_asset_id" TEXT,
    "production_date" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LarkRecord_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "LarkRecord_production_date_idx" ON "LarkRecord"("production_date");

-- CreateIndex
CREATE INDEX "LarkRecord_brand_code_product_code_idx" ON "LarkRecord"("brand_code", "product_code");

-- CreateIndex
CREATE INDEX "LarkRecord_creative_asset_id_idx" ON "LarkRecord"("creative_asset_id");

-- AddForeignKey
ALTER TABLE "LarkRecord" ADD CONSTRAINT "LarkRecord_creative_asset_id_fkey" FOREIGN KEY ("creative_asset_id") REFERENCES "CreativeAsset"("id") ON DELETE SET NULL ON UPDATE CASCADE;
