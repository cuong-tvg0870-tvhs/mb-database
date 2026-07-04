-- Rào an toàn cho tự động hóa dựng nháp (DraftAutomation): trần số lượt, khóa chạy
-- nguyên tử chống chồng lượt, và theo dõi nháp "đang gom dở" theo TỪNG row.
--
-- Tất cả cột đều NULLABLE + additive → NON-BREAKING với 2 writer đang chạy
-- (mb-ads run-now + mb-batch cron). Row cũ giữ NULL và hành vi không đổi:
--   • maxRuns           = NULL → không giới hạn số lượt (như trước).
--   • runLockedAt       = NULL → đang rảnh (chưa có tiến trình nào giữ khóa).
--   • inProgressDraftId = NULL → engine dùng heuristic cũ (template+creator+folder).
--
-- CÁC CỘT:
--   • maxRuns           : trần số lượt chạy. runCount đạt trần → tự chuyển COMPLETED,
--                         ngừng lịch (chống LOOP + PUBLISH_IMMEDIATELY đăng vô hạn).
--   • runLockedAt       : khóa chạy NGUYÊN TỬ. Claim bằng updateMany có điều kiện
--                         (null hoặc quá 30' = kẹt) → chỉ 1 tiến trình chạy 1 row tại
--                         một thời điểm (chống cron-tick trùng "Chạy ngay" / multi-replica
--                         → đăng đôi). Giải phóng khi lượt chạy xong.
--   • inProgressDraftId : id bản nháp đang gom dở của CHÍNH row này → engine tìm lại
--                         đúng nháp đó, thay heuristic template+creator+folder vốn có thể
--                         "cướp" nháp của một DraftAutomation khác cùng mẫu.
--
-- THỨ TỰ TRIỂN KHAI: chạy migration này TRƯỚC khi deploy code mới (mb-ads + mb-batch
-- đã đọc/ghi 3 cột này). Additive nên chạy trước lúc code cũ vẫn đang sống là an toàn.
ALTER TABLE "DraftAutomation"
    ADD COLUMN "maxRuns"           INTEGER,
    ADD COLUMN "runLockedAt"       TIMESTAMP(3),
    ADD COLUMN "inProgressDraftId" TEXT;
