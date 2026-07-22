-- Email thông báo cho CHỦ quy tắc "Scale bài hiệu quả" khi tạo camp hoặc lỗi.
-- Mặc định TẮT để toàn bộ rule cũ giữ nguyên hành vi sau rollout.
-- `completedAt` là mốc kết thúc thật: run dùng status FAILED làm CLAIM tạm
-- trong lúc còn publish, nên notify service không được chỉ nhìn status.
-- `notifiedAt` được claim nguyên tử trước khi gửi để nhiều replica không bắn trùng.
--
-- Additive/non-breaking: chỉ thêm cột nullable/default và index; mb-ads/mb-batch
-- cũ vẫn đọc-ghi được trong thời gian rolling deploy.
-- KHÔNG apply migration tự động từ workspace này; người vận hành deploy riêng.

ALTER TABLE "auto_launch_rule"
    ADD COLUMN "notifyOnLaunch" BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN "notifyOnError" BOOLEAN NOT NULL DEFAULT false;

ALTER TABLE "auto_launch_rule_run"
    ADD COLUMN "completedAt" TIMESTAMP(3),
    ADD COLUMN "notifiedAt" TIMESTAMP(3);

CREATE INDEX "auto_launch_rule_run_notifiedAt_completedAt_idx"
    ON "auto_launch_rule_run"("notifiedAt", "completedAt");
