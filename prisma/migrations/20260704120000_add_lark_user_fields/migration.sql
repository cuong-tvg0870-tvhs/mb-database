-- Đồng bộ User ↔ danh bạ Lark (Lark Contact API, tra theo email).
-- Tất cả cột đều NULLABLE + additive → non-breaking với 2 writer đang chạy
-- (mb-ads publish tay + mb-batch cron). User tạo tay/không có trên Lark vẫn hợp lệ.
--
-- `employee_id` (đã có sẵn) = Lark `employee_no` (mã số nhân viên) → không thêm lại.
--
--  • avatar            : URL avatar (Lark avatar_240) hiển thị ở list/detail.
--  • larkOpenId        : open_id — ID dùng GỬI TIN NHẮN/notify & đẩy Larkbase sau này.
--  • larkUserId        : user_id nội bộ tenant Lark.
--  • larkUnionId       : union_id ổn định cross-app.
--  • larkMobile        : số điện thoại danh bạ.
--  • larkJobTitle      : chức danh.
--  • larkDepartmentIds : string[] open_department_id (JSONB).
--  • larkRaw           : payload get-user đầy đủ (dự phòng, không đóng đinh cột).
--  • larkSyncedAt      : lần cuối đồng bộ thành công từ Lark.
ALTER TABLE "User"
    ADD COLUMN "avatar"            TEXT,
    ADD COLUMN "larkOpenId"        TEXT,
    ADD COLUMN "larkUserId"        TEXT,
    ADD COLUMN "larkUnionId"       TEXT,
    ADD COLUMN "larkMobile"        TEXT,
    ADD COLUMN "larkJobTitle"      TEXT,
    ADD COLUMN "larkDepartmentIds" JSONB,
    ADD COLUMN "larkRaw"           JSONB,
    ADD COLUMN "larkSyncedAt"      TIMESTAMP(3);

-- Unique lark open_id: một user Lark chỉ map tới một tài khoản MB. Postgres mặc định
-- NULLS DISTINCT → các user chưa liên kết Lark (larkOpenId NULL) không bị ảnh hưởng.
-- (Bảng đang chưa có dữ liệu Lark nên không cần dedup-check trước deploy.)
CREATE UNIQUE INDEX "User_larkOpenId_key" ON "User"("larkOpenId");
