-- Thêm cột metaBudgetScheduleIds (String[]) vào campaign_rule_run_item.
-- Lưu id HighDemandPeriod (budget_schedule) Meta trả về để sau TẮT/XOÁ được trên Meta.
-- Thuần additive (ADD COLUMN default '{}').

ALTER TABLE "campaign_rule_run_item"
  ADD COLUMN "metaBudgetScheduleIds" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[];
