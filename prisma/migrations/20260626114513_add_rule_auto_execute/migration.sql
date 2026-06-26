-- Per-rule "fully automatic" flag: when true, the runner auto-confirms matched
-- items and enqueues the executor in the same tick (no manual confirm step).
ALTER TABLE "AutomationRule" ADD COLUMN "autoExecute" BOOLEAN NOT NULL DEFAULT false;
