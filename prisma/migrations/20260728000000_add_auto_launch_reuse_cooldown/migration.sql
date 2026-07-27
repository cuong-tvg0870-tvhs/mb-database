-- Chống spam scale per-creative cho "Tự lên Camp" (auto_launch_rule).
--
-- Trước đây: bài đã dùng bị loại VĨNH VIỄN (ledger usedCreatives, chừng nào camp còn sống).
-- Sau migration: mỗi bài chỉ phải "nghỉ" đủ `reuseCooldownMinutes` phút kể từ lần scale
-- gần nhất là được chọn lại. Backfill 1440 (= 1 ngày) cho MỌI rule hiện có — chủ đích
-- đổi hành vi mặc định thành "mỗi bài tối đa 1 lần/ngày". NULL = không bao giờ dùng lại
-- (user chọn tay trong form nếu muốn giữ hành vi cũ).
--
-- `maxUsePerCreative`: trần tổng số lần 1 bài được rule scale (đếm camp còn sống,
-- xoá camp thì hoàn lượt). NULL = không giới hạn — giữ nguyên cho rule hiện có.
--
-- Additive, không đổi/xoá cột → an toàn rolling deploy (mb-ads/mb-batch cũ chưa đọc
-- cột mới vẫn chạy bình thường; áp migration TRƯỚC khi deploy code mới).

ALTER TABLE "auto_launch_rule"
  ADD COLUMN "reuseCooldownMinutes" INTEGER DEFAULT 1440,
  ADD COLUMN "maxUsePerCreative" INTEGER;
