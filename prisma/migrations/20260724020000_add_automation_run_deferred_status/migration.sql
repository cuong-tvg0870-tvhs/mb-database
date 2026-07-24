-- Thêm trạng thái DEFERRED cho AutomationRuleRunStatus.
-- Meta không phục vụ được data của run NGAY LÚC NÀY (lỗi transient #1/#2/5xx, bị
-- throttle, hoặc do pacing của chính ta) nên run được HOÃN để retry NGAY TRONG
-- cùng schedule slot. KHÔNG terminal và KHÔNG phải failure: cùng row run sẽ được
-- đưa lại RUNNING khi retry bắt đầu. Phạt của Meta chỉ tính bằng giây→phút, nên
-- retry rẻ hơn nhiều so với bỏ nguyên 1 interval — vốn là kết cục duy nhất trước
-- đây với rule interval dài (tới 72h).
-- Additive/non-breaking: chỉ bổ sung value vào enum, run cũ không đổi.
--
-- Tách RIÊNG khỏi migration thêm cột (20260724030000): Postgres KHÔNG cho dùng
-- một enum value vừa ADD trong cùng transaction; để value được commit trước rồi
-- migration sau mới an toàn tham chiếu/sử dụng.

ALTER TYPE "AutomationRuleRunStatus" ADD VALUE 'DEFERRED';
