-- CreateTable
CREATE TABLE "ExportPreset" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "exportType" TEXT NOT NULL,
    "filterConfig" JSONB NOT NULL,
    "columnConfig" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ExportPreset_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ExportPreset_userId_exportType_idx" ON "ExportPreset"("userId", "exportType");

-- CreateIndex
CREATE UNIQUE INDEX "ExportPreset_userId_exportType_name_key" ON "ExportPreset"("userId", "exportType", "name");

-- AddForeignKey
ALTER TABLE "ExportPreset" ADD CONSTRAINT "ExportPreset_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
