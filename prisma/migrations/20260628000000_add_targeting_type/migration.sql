-- Add `type` discriminator to TargetingInterest so it can cache
-- behaviors / demographics / life_events / locales (not just interests).
-- Existing rows default to 'interests'. Idempotent for safe prod apply.
ALTER TABLE "TargetingInterest" ADD COLUMN IF NOT EXISTS "type" TEXT NOT NULL DEFAULT 'interests';
CREATE INDEX IF NOT EXISTS "TargetingInterest_type_idx" ON "TargetingInterest"("type");
