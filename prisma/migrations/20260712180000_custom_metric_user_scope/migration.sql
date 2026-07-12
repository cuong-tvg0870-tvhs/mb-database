-- Thêm scope USER cho CustomMetric: cho phép user tự định nghĩa metric tính toán
-- (phép toán trên chỉ số insight) hiển thị trên bảng list/detail. Additive.

ALTER TYPE "CustomMetricScope" ADD VALUE IF NOT EXISTS 'USER';
