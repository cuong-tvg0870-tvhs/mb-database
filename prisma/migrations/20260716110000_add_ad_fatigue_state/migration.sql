-- Materialize trạng thái "mệt mỏi quảng cáo" theo từng Ad để API có thể lọc
-- đúng trước khi phân trang và UI giải thích cảnh báo mà không tính lại mỗi lần đọc.
-- Additive, non-breaking: chỉ thêm enum/bảng 1:1; không thay đổi bảng insight hay
-- hành vi phân phối hiện có. Worker chỉ ghi snapshot, tuyệt đối không tự tắt Ad.
-- KHÔNG apply migration tự động từ workspace này; người vận hành sẽ deploy riêng.

-- CreateEnum
CREATE TYPE "AdFatigueStatus" AS ENUM (
    'INSUFFICIENT_DATA',
    'HEALTHY',
    'WATCH',
    'FATIGUED'
);

-- CreateTable
CREATE TABLE "ad_fatigue_state" (
    "adId" TEXT NOT NULL,
    "status" "AdFatigueStatus" NOT NULL DEFAULT 'INSUFFICIENT_DATA',
    "score" INTEGER NOT NULL DEFAULT 0,
    "reasons" JSONB,
    "frequency" DOUBLE PRECISION,
    "currentCtr" DOUBLE PRECISION,
    "previousCtr" DOUBLE PRECISION,
    "ctrDropRate" DOUBLE PRECISION,
    "currentImpressions" INTEGER,
    "previousImpressions" INTEGER,
    "currentSpend" DOUBLE PRECISION,
    "ruleVersion" TEXT NOT NULL DEFAULT 'v1',
    "evaluatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "detectedAt" TIMESTAMP(3),
    "resolvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ad_fatigue_state_pkey" PRIMARY KEY ("adId")
);

-- CreateIndex
CREATE INDEX "ad_fatigue_state_status_evaluatedAt_idx"
    ON "ad_fatigue_state"("status", "evaluatedAt" DESC);

-- AddForeignKey
ALTER TABLE "ad_fatigue_state"
    ADD CONSTRAINT "ad_fatigue_state_adId_fkey"
    FOREIGN KEY ("adId") REFERENCES "Ad"("id")
    ON DELETE CASCADE ON UPDATE CASCADE;
