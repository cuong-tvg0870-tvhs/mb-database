-- Attribution window for the Insights fetch (Bir.ch "Attribution window").
-- `useAdSetAttributionWindow` defaults to true so existing rules keep using the
-- ad set's own window (no behavior change). `attributionWindow` holds a preset
-- key when the user pins a specific window.
ALTER TABLE "AutomationRule" ADD COLUMN "useAdSetAttributionWindow" BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE "AutomationRule" ADD COLUMN "attributionWindow" TEXT;
