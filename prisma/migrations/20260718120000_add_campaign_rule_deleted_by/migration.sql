-- Truy vết "ai đã xóa" lịch tăng ngân sách (campaign_rule) khi soft-delete.
-- Additive, non-breaking: cột nullable, rule cũ (kể cả đã xóa trước đây) = NULL.
-- Cột này cặp với ChangeLog action DELETE_CAMPAIGN_RULE (ghi ai/khi nào/snapshot).
-- KHÔNG có FK tới User (giữ nguyên pattern scalar như createdById, User ngoài cụm).
ALTER TABLE "campaign_rule" ADD COLUMN "deletedById" TEXT;
