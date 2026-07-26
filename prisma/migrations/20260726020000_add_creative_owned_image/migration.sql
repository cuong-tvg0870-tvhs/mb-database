-- Migration: ẢNH OWNED cho Creative (re-host media Meta lên MinIO tự host).
--
-- Bối cảnh: ảnh/video của creative LIVE hiển thị ở list/detail mẫu QC lấy URL từ Meta CDN
-- (Creative.imageUrl/thumbnailUrl/previewUrl, adImage.url, adVideo thumbnails). Các URL này
-- HẾT HẠN (xem cột urlExpiredAt) → sau vài ngày là VỠ ẢNH. Giải pháp: mb-batch tải BẢN NÉT
-- nhất về, đẩy lên MinIO (bucket `media`, serve qua https://ads.3fastvn.com/media/<key> —
-- cùng origin với FE, không CORS), rồi lưu URL bền vào 3 cột dưới đây.
--
-- Vì sao đặt trên Creative (không phải AdImage/AdVideo): Creative là ĐƠN VỊ HIỂN THỊ ở
-- list/detail; ~10% creative hiển thị bằng field thẳng (imageUrl/thumbnailUrl) mà KHÔNG có
-- quan hệ adImage/adVideo → đặt ở bảng dedup sẽ bỏ sót nhóm này. Cột chỉ lưu 1 CHUỖI URL
-- (~60 byte), KHÔNG lưu binary; ảnh thật nằm 1 bản deduped trong MinIO (job key theo
-- imageHash/videoId nên nhiều creative dùng chung 1 asset chỉ upload 1 lần).
--
-- Chọn "ảnh đẹp": video → uri có width LỚN NHẤT trong rawPayload.thumbnails.data[] (~1080px,
-- 94% video có sẵn) chứ KHÔNG lấy thumbnailUrl nhỏ (bị mờ); image → AdImage.url (full-res,
-- avg 1462px); orphan → imageUrl → previewUrl → thumbnailUrl.
--
-- An toàn: chỉ ADD COLUMN nullable → metadata-only, tức thì, KHÔNG rewrite bảng (dù Creative
-- 45k dòng), KHÔNG backfill, KHÔNG khoá lâu. Writer cũ (mb-ads/mb-batch bản trước) không đụng
-- cột → back-compat; meta-sync vẫn ghi field Meta cũ → parity giữ nguyên. Rollout lúc nào cũng được.

ALTER TABLE "Creative" ADD COLUMN     "ownedImageUrl" TEXT;
ALTER TABLE "Creative" ADD COLUMN     "ownedImageKey" TEXT;
ALTER TABLE "Creative" ADD COLUMN     "ownedImageAt" TIMESTAMP(3);
