-- Truy vết "mẫu quy tắc lịch đã áp cho chiến dịch nào": khi user bấm "Dùng mẫu" rồi tạo
-- campaign_rule, đóng dấu CampaignRuleTemplate.id vào cột này. Từ đó đếm được "mẫu đã áp
-- cho bao nhiêu chiến dịch" → mẫu nào hiệu quả thì giữ, mẫu nào chưa ai dùng (0) thì clear.
--
-- CHỈ tính từ lúc thêm cột trở đi: rule tạo trước migration = NULL (áp mẫu trước đây là
-- thao tác thuần frontend, không lưu vết mẫu gốc) — không thể lấp ngược.
--
-- Additive, non-breaking: chỉ THÊM 1 cột nullable (không DEFAULT bắt buộc) + 1 index; không
-- đụng cột/bảng sẵn có nên 2 writer (mb-ads, mb-batch) đang chạy không gãy.
-- KHÔNG apply migration tự động từ workspace này; người vận hành sẽ deploy riêng.

-- AlterTable: mẫu gốc đã áp (nullable → rule cũ = null; scalar, không FK vì mẫu ngoài cụm scope)
ALTER TABLE "campaign_rule"
    ADD COLUMN "sourceTemplateId" TEXT;

-- CreateIndex: đếm nhanh số campaign theo từng mẫu
CREATE INDEX "campaign_rule_sourceTemplateId_idx" ON "campaign_rule"("sourceTemplateId");
