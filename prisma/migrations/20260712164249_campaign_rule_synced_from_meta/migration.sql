-- Cờ đánh dấu bản ghi campaign_rule là "gương" phản chiếu budget schedules trên Meta
-- (do job sync campaign upsert). Thuần additive.
ALTER TABLE "campaign_rule"
  ADD COLUMN "syncedFromMeta" BOOLEAN NOT NULL DEFAULT false;
