-- MẪU CHIẾN DỊCH: tách "mẫu dùng để LÀM GÌ" (purpose) ra khỏi TÊN campaign, và cho mẫu một
-- hợp đồng launch (launchContract) sống ở CỘT RIÊNG.
--
-- Vì sao cần:
-- 1. `purpose`. Hôm nay thứ duy nhất đóng vai "mục đích của mẫu" là substring 'testingcontent'
--    trong TÊN campaign, bị đọc ở 7 điểm thực thi qua 3 repo (mb-ads, mb-batch, mb-frontend) —
--    chủ yếu để MIỄN cổng min-5-content. Đổi tên chiến dịch là vô tình đổi hành vi validate.
--    Cột enum có index thay thế cách đó.
-- 2. `launchContract`. KHÔNG được nhét vào cột `data` sẵn có: `updateTemplate` ghi
--    `data: slottedValues` ĐÈ TOÀN BỘ cột data, còn ValidationPipe(whitelist:true) cắt mọi field
--    không khai trong DTO. Cơ chế đó hôm nay đang xoá mất `description` mỗi lần lưu mẫu — hợp
--    đồng launch sẽ chịu đúng số phận đó nếu ở chung `data`.
-- 3. `locked`. Mẫu là cấu hình chiến lược đã duyệt nên không cho sửa trực tiếp objective,
--    targeting hay placement. Marketer vẫn đổi metadata/chế độ qua quick-edit, còn khi cần
--    sửa cấu trúc thì nhân bản để giữ mẫu gốc an toàn.
--
-- Additive, non-breaking:
--  - Cả 3 cột đều nullable / có DEFAULT ⇒ writer cũ (mb-ads + mb-batch bản chưa deploy) không
--    biết tới chúng vẫn INSERT/UPDATE bình thường.
--  - `purpose` cho phép NULL trong lúc chuyển đổi để writer cũ không vỡ; cùng migration này sẽ
--    backfill mọi mẫu có data. UI coi NULL là STANDARD, còn automation fail-closed cho an toàn.
--  - `launchContract` NULL = permissive (không khoá mode nào).
--
-- Backfill phía dưới idempotent, chỉ đụng row đang NULL.

CREATE TYPE "TemplatePurpose" AS ENUM ('TESTING_CONTENT', 'SCALE_POST_WIN', 'STANDARD');

ALTER TABLE "TemplateCampaign" ADD COLUMN "purpose" "TemplatePurpose";
ALTER TABLE "TemplateCampaign" ADD COLUMN "launchContract" JSONB;
ALTER TABLE "TemplateCampaign" ADD COLUMN "locked" BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX "TemplateCampaign_purpose_idx" ON "TemplateCampaign"("purpose");

-- BACKFILL: suy purpose từ đúng tín hiệu mà code CŨ đang dùng, để hành vi không đổi ở thời
-- điểm deploy. Chỉ ghi vào row còn NULL nên chạy lại nhiều lần vẫn an toàn.
--
-- Quan hệ automation là tín hiệu mạnh nhất: giữ cho các rule/automation đang chạy tiếp tục
-- chọn được đúng template sau khi UI và runner chuyển sang kiểm purpose tường minh.
UPDATE "TemplateCampaign" t
SET "purpose" = 'SCALE_POST_WIN'
WHERE t."purpose" IS NULL
  AND EXISTS (
    SELECT 1 FROM "auto_launch_rule" r
    WHERE r."templateId" = t."id" AND r."deletedAt" IS NULL
  );

UPDATE "TemplateCampaign" t
SET "purpose" = 'TESTING_CONTENT'
WHERE t."purpose" IS NULL
  AND EXISTS (
    SELECT 1 FROM "DraftAutomation" a
    WHERE a."templateId" = t."id" AND a."deletedAt" IS NULL
  );

-- 'testingcontent' được dò trong TÊN MẪU và trong tên campaign nằm ở data->'campaign'->>'name',
-- vì đó chính là hai chỗ code cũ đọc. Dấu cách/gạch dưới bị bỏ trước khi so khớp (tên thật có
-- cả "Testing Content" lẫn "TestingContent").
UPDATE "TemplateCampaign"
SET "purpose" = 'TESTING_CONTENT'
WHERE "purpose" IS NULL
  AND (
    replace(replace(lower("name"), ' ', ''), '_', '') LIKE '%testingcontent%'
    OR replace(replace(lower(COALESCE("data"->'campaign'->>'name', '')), ' ', ''), '_', '')
       LIKE '%testingcontent%'
  );

-- Mẫu scale: nhận diện bằng việc mẫu GHIM bài viết (creative.pinnedPost = true) — dấu hiệu
-- mẫu được dựng để dùng lại object_story_id của một bài đã thắng.
UPDATE "TemplateCampaign" t
SET "purpose" = 'SCALE_POST_WIN'
WHERE t."purpose" IS NULL
  AND EXISTS (
    SELECT 1
    FROM jsonb_array_elements(COALESCE(t."data"->'ad_sets', '[]'::jsonb)) AS adset,
         jsonb_array_elements(COALESCE(adset->'ads', '[]'::jsonb)) AS ad
    WHERE (ad->'creative'->>'pinnedPost') = 'true'
  );

-- Phần còn lại là mẫu thường. Đặt tường minh thay vì để NULL để về sau phân biệt được
-- "chưa phân loại" với "đã xét và là mẫu thường".
UPDATE "TemplateCampaign"
SET "purpose" = 'STANDARD'
WHERE "purpose" IS NULL AND "data" IS NOT NULL;

-- KHÔNG backfill `locked`: khoá là OPT-IN. `updateTemplate` hiện là đường DUY NHẤT để vá
-- một mẫu hỏng, nên khoá đại trà 95 mẫu đang dùng sẽ giết một tính năng đang chạy. Mẫu nào
-- cần khoá thì người dùng tự bật trong quick-edit.
