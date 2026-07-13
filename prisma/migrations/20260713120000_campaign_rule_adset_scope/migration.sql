-- Thêm scope theo NHÓM QUẢNG CÁO cho lịch tăng ngân sách (ABO: mỗi nhóm 1 lịch riêng).
-- THUẦN ADDITIVE: chỉ thêm 1 cột nullable + 1 index. Không phá dữ liệu cũ:
--   - Bản ghi cũ (CBO / phủ account) giữ adSetId = NULL → hành vi không đổi.
--   - Bản ghi ABO mới sẽ set adSetId = AdSet.id để tách lịch từng nhóm.
-- Viết tay (KHÔNG `prisma migrate dev`) theo quy ước repo — .env trỏ tunnel PROD.

ALTER TABLE "campaign_rule" ADD COLUMN "adSetId" TEXT;

CREATE INDEX "campaign_rule_campaignId_adSetId_status_idx"
  ON "campaign_rule" ("campaignId", "adSetId", "status");
