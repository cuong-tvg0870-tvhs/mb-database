-- Mục đích: cho phép cấu hình "Tự động hoá sau khi lên Camp" (lịch tăng ngân sách theo
-- khung giờ + bộ rule theo điều kiện) NGAY khi dựng bản nháp và khi dựng MẪU, để khi
-- publish lên Meta (kể cả campaign do automation sinh ra từ mẫu) thì tự áp — tái dùng
-- nguyên engine CampaignRule sẵn có, KHÔNG đụng campaign đang chạy / model legacy.
--
-- Thêm 2 cột JSON nullable:
--   * SystemCampaign.pendingAutomation  — config gắn theo BẢN NHÁP. Khi publish thành công
--       (đã có meta_id campaign + meta_id ad set), mb-ads pushToMetaCore / mb-batch
--       publishDraftCampaign VẬT CHẤT HOÁ thành CampaignRule thật (campaignId = meta_id):
--       khung giờ → applyToMeta đẩy HighDemandPeriod; điều kiện → tạo rule status=ACTIVE
--       cho campaign-rule-runner nhặt. Sau khi áp, ghi ngược appliedRuleIds/appliedAt vào
--       từng entry (idempotent: republish bỏ qua entry đã có ruleId còn sống).
--   * TemplateCampaign.pendingAutomation — config gắn theo MẪU; được NHÂN xuống mọi
--       SystemCampaign sinh ra từ mẫu (cron DraftAutomation / auto-launch / "Lên Camp từ
--       mẫu") ở bước saveAutomationDraft, rồi đi theo luồng publish ở trên.
--
-- Vì sao là CỘT RIÊNG (không nhét vào `data`): cùng lý do launchContract —
--   (1) updateTemplate ghi `data: slottedValues` ĐÈ TOÀN BỘ cột data;
--   (2) ValidationPipe(whitelist:true) cắt field lạ khỏi payload;
--   (3) lần lưu nháp của FE chỉ gửi phần CONFIG → nếu chung chỗ với data sẽ xoá mất
--       materialization-state (appliedRuleIds) → mất idempotency. Cột riêng để backend
--       merge theo `uid` mà không bị FE ghi đè.
--
-- An toàn: cả 2 cột NULLABLE, không default. NULL = không kèm tự động hoá (mọi bản nháp /
-- mẫu cũ) → additive thuần. Không writer nào (mb-ads/mb-batch) dựa vào cột này; runner chỉ
-- chạy CampaignRule status=ACTIVE + có campaignId, nên config chưa publish không chạy nhầm.
--
-- Rollout: apply lúc nào cũng được, không cần dừng writer. Không backfill, không index
-- (không truy vấn/lọc theo cột này).

-- AlterTable
ALTER TABLE "SystemCampaign" ADD COLUMN     "pendingAutomation" JSONB;

-- AlterTable
ALTER TABLE "TemplateCampaign" ADD COLUMN     "pendingAutomation" JSONB;
