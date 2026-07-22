-- Mục đích: truy vết "mẫu (TemplateCampaign) nào đã tạo ra campaign nào".
-- Thêm cột `sourceTemplateId` trên SystemCampaign để đánh dấu campaign được sinh ra
-- TỪ mẫu nào — dùng cho màn "Mẫu chiến dịch" (đếm/liệt kê camp đã tạo từ mỗi mẫu) và
-- cho dialog "xem camp đã tạo" trên thẻ rule Tự lên Camp.
--
-- Vì sao cần cột MỚI thay vì tái dùng `automationTemplateId`:
--   `automationTemplateId` chỉ được ghi ở luồng AUTOMATION (rule Tự lên Camp). Luồng
--   THỦ CÔNG "Lên Camp từ mẫu" (POST /draft-campaigns/full) trước nay KHÔNG lưu bất kỳ
--   liên kết template nào. `sourceTemplateId` là cột thống nhất cho CẢ HAI luồng:
--     * automation: = automationTemplateId (backfill bên dưới)
--     * thủ công:   FE gửi kèm khi tạo nháp (áp dụng từ nay trở đi)
--
-- Back-compat: cột NULLABLE, không default. Camp thủ công CŨ không truy hồi được vì
-- dữ liệu chưa từng lưu → giữ NULL (app hiểu NULL = không rõ nguồn mẫu). Additive thuần,
-- không phá vỡ writer nào (mb-ads/mb-batch chỉ đọc/ghi thêm, không dựa vào cột này).
--
-- Rollout: apply lúc nào cũng được, không cần dừng writer.

-- AlterTable
ALTER TABLE "SystemCampaign" ADD COLUMN     "sourceTemplateId" TEXT;

-- Backfill: camp do automation tạo đã có sẵn automationTemplateId → chép sang cột thống
-- nhất. Idempotent (chỉ đụng dòng đang NULL nhưng có automationTemplateId), chạy lại an toàn.
UPDATE "SystemCampaign"
SET "sourceTemplateId" = "automationTemplateId"
WHERE "sourceTemplateId" IS NULL
  AND "automationTemplateId" IS NOT NULL;

-- CreateIndex
CREATE INDEX "SystemCampaign_sourceTemplateId_createdAt_idx" ON "SystemCampaign"("sourceTemplateId", "createdAt" DESC);
