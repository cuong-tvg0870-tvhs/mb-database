-- Add Meta effective_status / configured_status to Campaign and AdSet.
-- (Ad already had these columns.) Nullable -> additive & non-breaking; rows
-- backfill on the next Meta sync. Display falls back to `status` until then.
ALTER TABLE "Campaign" ADD COLUMN "effectiveStatus" TEXT;
ALTER TABLE "Campaign" ADD COLUMN "configuredStatus" TEXT;
ALTER TABLE "AdSet" ADD COLUMN "effectiveStatus" TEXT;
ALTER TABLE "AdSet" ADD COLUMN "configuredStatus" TEXT;
