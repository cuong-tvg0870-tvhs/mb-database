/*
  Warnings:

  - Changed the type of `type` on the `AssetAccessRequestItem` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "AssetAccessRequestItem" DROP COLUMN "type",
ADD COLUMN     "type" "AssetAccessType" NOT NULL;

-- CreateIndex
CREATE INDEX "AssetAccessRequestItem_type_metaId_idx" ON "AssetAccessRequestItem"("type", "metaId");
