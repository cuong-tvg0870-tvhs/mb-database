-- VÁ DỮ LIỆU: mẫu đang có DraftAutomation sống phải mang purpose 'TESTING_CONTENT'.
--
-- Vì sao cần một migration RIÊNG thay vì sửa lại 20260721090000:
--   Migration đó ĐÃ apply lên prod (2026-07-20 18:03). Bản đã chạy thiếu quy tắc backfill
--   "mẫu có DraftAutomation → TESTING_CONTENT"; quy tắc được thêm vào file SAU khi apply
--   nên không bao giờ chạy. Sửa tiếp file cũ cũng vô ích: Prisma không chạy lại migration
--   đã ghi trong _prisma_migrations, chỉ tạo ra drift.
--
-- Hậu quả trên prod (đã đo): 3/4 automation trỏ vào mẫu bị phân loại 'STANDARD'. Cổng
-- purpose trong runner (mb-batch draft-automation.scheduler) trả SKIPPED ngay, còn mb-ads
-- chặn cả đường update — nghĩa là automation vừa không chạy được vừa không sửa được.
--
-- Idempotent: chỉ đụng row chưa phải TESTING_CONTENT và thực sự có automation sống. Chạy
-- lại nhiều lần vẫn an toàn; trên prod (đã vá tay ngày 21/07) sẽ khớp 0 dòng.
--
-- KHÔNG đổi schema — data-only.

UPDATE "TemplateCampaign" t
SET "purpose" = 'TESTING_CONTENT'
WHERE t."purpose" IS DISTINCT FROM 'TESTING_CONTENT'
  AND EXISTS (
    SELECT 1 FROM "DraftAutomation" a
    WHERE a."templateId" = t."id" AND a."deletedAt" IS NULL
  );
