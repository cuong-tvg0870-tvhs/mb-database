-- Thông báo CHỦ ĐỘNG qua email khi campaign_rule chạy: user opt-in per-rule để nhận
-- mail real-time khi rule ĐỦ ĐIỀU KIỆN (matched) / ĐÃ ĐẨY META (executed) / LỖI (failed).
-- Người nhận chọn nhiều (bảng junction). Chống gửi trùng bằng cột notifiedAt trên run-item
-- (1 mail / sự kiện). Runner mb-batch chỉ ĐÁNH DẤU; cron mb-ads gửi mail (mailer nằm ở mb-ads).
--
-- Additive, non-breaking: chỉ THÊM cột (đều có DEFAULT / nullable) + 1 bảng junction mới;
-- không đụng cột/bảng sẵn có nên 2 writer (mb-ads, mb-batch) đang chạy không gãy.
-- Giữ nguyên `notifyErrorsOnly` legacy (không dùng cho luồng này).
-- KHÔNG apply migration tự động từ workspace này; người vận hành sẽ deploy riêng.

-- AlterTable: cờ opt-in per-rule (mặc định TẮT → rule cũ không tự gửi mail)
ALTER TABLE "campaign_rule"
    ADD COLUMN "notifyOnMatch" BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN "notifyOnExecute" BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN "notifyOnError" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable: dấu "đã gửi mail" cho từng item (nullable → item cũ = chưa/không gửi)
ALTER TABLE "campaign_rule_run_item"
    ADD COLUMN "notifiedAt" TIMESTAMP(3);

-- CreateTable: người nhận email của 1 rule (chọn nhiều)
CREATE TABLE "campaign_rule_notify_user" (
    "ruleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "campaign_rule_notify_user_pkey" PRIMARY KEY ("ruleId","userId")
);

-- CreateIndex
CREATE INDEX "campaign_rule_notify_user_userId_idx" ON "campaign_rule_notify_user"("userId");

-- AddForeignKey
ALTER TABLE "campaign_rule_notify_user"
    ADD CONSTRAINT "campaign_rule_notify_user_ruleId_fkey"
    FOREIGN KEY ("ruleId") REFERENCES "campaign_rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;
