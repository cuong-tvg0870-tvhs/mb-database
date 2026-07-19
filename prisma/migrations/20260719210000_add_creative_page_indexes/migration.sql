-- Index cho lọc list theo Fanpage (page_id) ở Campaign/AdSet/Ad/Creative.
-- Các list cấp trên lọc bằng EXISTS lồng tới Creative theo pageId/systemPageId;
-- không có index thì subquery quét toàn bảng Creative (chậm trên account lớn).
-- Additive, non-breaking: chỉ thêm index. Dùng IF NOT EXISTS cho an toàn khi
-- apply nhiều lần / DB đã có index tay.
CREATE INDEX IF NOT EXISTS "Creative_pageId_idx" ON "Creative"("pageId");
CREATE INDEX IF NOT EXISTS "Creative_systemPageId_idx" ON "Creative"("systemPageId");
