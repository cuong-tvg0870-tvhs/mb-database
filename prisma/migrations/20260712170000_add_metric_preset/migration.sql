-- Bộ chỉ số insight tùy biến per-user cho màn list/detail (campaign/adset/ad/creative).
-- Additive, không đụng model legacy. Áp dụng sau khi review (chưa apply prod tự động).

-- CreateTable
CREATE TABLE "MetricPreset" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "scope" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "metrics" JSONB NOT NULL,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MetricPreset_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "MetricPreset_userId_scope_idx" ON "MetricPreset"("userId", "scope");

-- CreateIndex
CREATE UNIQUE INDEX "MetricPreset_userId_scope_name_key" ON "MetricPreset"("userId", "scope", "name");

-- AddForeignKey
ALTER TABLE "MetricPreset" ADD CONSTRAINT "MetricPreset_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
