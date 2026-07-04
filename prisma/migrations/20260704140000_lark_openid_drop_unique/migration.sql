-- Bỏ UNIQUE trên larkOpenId → cho phép NHIỀU tài khoản MB cùng trỏ 1 người Lark.
-- Lý do: cùng một người có thể có 2 email công ty (@tvhs.asia & @thanhvinhgroup.com)
-- và muốn là 2 TÀI KHOẢN RIÊNG BIỆT, mỗi tài khoản vẫn kéo đúng info từ Lark
-- (cùng open_id). Thay bằng index thường để tra nhanh mọi account của 1 người
-- (gửi notify/đẩy Larkbase). Additive/non-breaking: larkOpenId hiện toàn NULL
-- (backfill chưa chạy) nên đổi index không đụng dữ liệu.
DROP INDEX IF EXISTS "User_larkOpenId_key";
CREATE INDEX IF NOT EXISTS "User_larkOpenId_idx" ON "User"("larkOpenId");
