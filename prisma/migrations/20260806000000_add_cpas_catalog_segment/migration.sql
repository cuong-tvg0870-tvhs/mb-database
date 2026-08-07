-- CPAS / Collaborative Ads ("Quảng cáo cộng tác"): nhận diện catalog segment của nhà bán lẻ
-- và ánh xạ TKQC ↔ segment.
--
-- BỐI CẢNH: luồng Catalog + Product Set (Advantage+ catalog ads / DPA) ĐÃ chạy được end-to-end
-- trong hệ thống — FE gửi campaign `promoted_object.product_catalog_id` (payload.ts) và ad set
-- `promoted_object.product_set_id`, backend build payload tương ứng (meta.service.ts). CPAS về
-- mặt API KHÔNG phải một loại campaign khác: nó là đúng luồng catalog đó, chỉ thay catalog id
-- bằng CATALOG SEGMENT ID do nhà bán lẻ chia sẻ sang Business của mình.
--
-- CÁI THIẾU THẬT SỰ là hai mảnh dữ liệu, cả hai đều KHÔNG tồn tại ở bất kỳ đâu hôm nay:
--
--  (1) "Catalog này là của mình hay là segment đối tác chia sẻ?" — `syncCatalogs` ở CẢ HAI
--      writer gọi 3 edge (owned_product_catalogs / client_product_catalogs /
--      assigned_product_catalogs) rồi gộp PHẲNG vào một map, nên nguồn gốc bị mất ngay tại
--      chỗ. Catalog đối tác VẪN ĐANG vào DB qua `client_product_catalogs`, chỉ là không ai
--      phân biệt được. → cột isCatalogSegment / sourceEdges / ownerBusinessName / lastSyncedAt.
--
--  (2) "TKQC nào được phép dùng segment nào?" — Meta ràng buộc mỗi TKQC chỉ chọn được segment
--      của ĐÚNG nhà bán lẻ đã liên kết. Hệ thống không lưu ánh xạ này: `ProductCatalog.accountId`
--      bị CẢ HAI writer ghi đè `accountId: null` ở CẢ nhánh create LẪN update mỗi lần sync, và
--      dropdown catalog là GLOBAL (không nhận accountId). → bảng CpasPartnership.
--
-- HỆ THỐNG ĐÓNG CẢ HAI VAI nên cần cả hai chiều quan hệ, và chúng KHÔNG đối xứng:
--   * vai NHÃN HÀNG  → `CpasPartnership`          : TKQC của mình dùng segment đối tác chia sang.
--   * vai NHÀ BÁN LẺ → `CpasCatalogSegmentShare`  : segment mình cắt ra chia cho Business nhãn hàng.
-- Lý do tách hai bảng thay vì một cột `direction` ghi ngay tại chỗ khai báo bảng thứ hai (mục 3b).
--
-- Các cột của CpasPartnership phản chiếu đúng hợp đồng `POST /{catalog_segment_id}/agencies`
-- trong tài liệu Meta (business / permitted_tasks / utm_settings / enabled_collab_terms) để
-- sau này đọc ngược từ `GET /{catalog_id}/collaborative_ads_share_settings` là map thẳng được.
-- ĐÃ ĐO THẬT trên Meta 07-08-2026 (business 1916878948527753, GET read-only) trước khi chốt cột:
--   * `is_catalog_segment` ĐỌC ĐƯỢC dù tài liệu không liệt kê — Meta trả đủ 44/44 catalog trên
--     CẢ HAI edge owned_product_catalogs (20) và client_product_catalogs (24).
--   * `collaborative_ads_share_settings` truy cập được trên cả 44 catalog, tất cả đều RỖNG.
--   * KHÔNG catalog nào là segment (is_catalog_segment=false toàn bộ) ⇒ hôm nay hệ thống CHƯA
--     có bất kỳ quan hệ CPAS nào. Đợt này chỉ dựng CHỖ CHỨA; muốn nghiệm thu phải bắt tay trên
--     Collaboration Center trước (thủ công trên UI Meta, KHÔNG có API).
--   * `segment_use_cases` không thấy trả về (có thể do chưa có segment nào để mà có use case)
--     ⇒ CỐ Ý không tạo cột cho nó, cũng như `vertical`. Thêm sau vẫn additive.
-- Vì vậy cột isCatalogSegment để nullable BA TRẠNG THÁI: NULL = chưa sync bằng code mới nên
-- chưa biết, false = đã đo và không phải segment, true = là segment.
--
-- BACK-COMPAT: additive tuyệt đối.
--   * 4 cột thêm vào "ProductCatalog" đều nullable hoặc có DEFAULT hằng → ALTER là metadata-only
--     (PG 11+), không rewrite bảng, không khoá lâu.
--   * Enum + bảng CpasPartnership là HOÀN TOÀN MỚI → không writer nào đang chạy biết tới, không
--     thể vỡ. Bảng RỖNG phải được tầng UI hiểu là "chưa khai báo gì" và FAIL-OPEN (không chặn
--     lựa chọn nào cả), KHÔNG phải "cấm hết" — nếu không, deploy sẽ khoá luôn luồng catalog
--     đang chạy tốt.
--   * KHÔNG đụng vào "ProductSet": catalog segment CŨNG LÀ một node ProductCatalog trên Meta và
--     có edge /product_sets bình thường, nên ProductSet.catalogId đã trỏ đúng sẵn.
--   * KHÔNG drop "ProductCatalog"."accountId" dù nó là cột chết (luôn null): hai writer dùng
--     chung DB, một bên vẫn có thể đang ghi vào đó. Chỉ đánh dấu @deprecated trong schema.
--
-- ROLLOUT: áp SQL này lên prod TRƯỚC khi deploy mb-ads/mb-batch. Vì hoàn toàn additive, chạy
-- sớm bao lâu cũng được — code cũ không thấy gì thay đổi. Hoàn tác KHÔNG được drop cột.

-- 1) Nhận diện catalog segment trên bảng catalog sẵn có.
ALTER TABLE "ProductCatalog" ADD COLUMN IF NOT EXISTS "isCatalogSegment" BOOLEAN;
ALTER TABLE "ProductCatalog" ADD COLUMN IF NOT EXISTS "sourceEdges" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[];
ALTER TABLE "ProductCatalog" ADD COLUMN IF NOT EXISTS "ownerBusinessName" TEXT;
ALTER TABLE "ProductCatalog" ADD COLUMN IF NOT EXISTS "lastSyncedAt" TIMESTAMP(3);

-- 1b) CHỈ dùng được cho segment DO CHÍNH MÌNH TẠO (vai nhà bán lẻ): lúc gọi
--     `POST /owned_product_catalogs` mình tự truyền parent_catalog_id + catalog_segment_filter
--     nên biết chắc; segment đối tác chia sẻ sang thì LUÔN NULL vì Meta không xác nhận đọc
--     ngược được. NULL = "không biết", KHÔNG phải "không có cha".
ALTER TABLE "ProductCatalog" ADD COLUMN IF NOT EXISTS "parentCatalogId" TEXT;
ALTER TABLE "ProductCatalog" ADD COLUMN IF NOT EXISTS "catalogSegmentFilter" JSONB;

-- 2) Trạng thái quan hệ hợp tác. ERROR ≠ REVOKED: gọi Meta lỗi (thiếu scope / token hỏng)
--    TUYỆT ĐỐI không được tự động suy ra là nhà bán lẻ đã thu hồi quyền.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'CpasPartnershipStatus') THEN
    CREATE TYPE "CpasPartnershipStatus" AS ENUM ('PENDING', 'ACTIVE', 'REVOKED', 'ERROR');
  END IF;
END
$$;

-- 3) CHIỀU NHẬN (vai NHÃN HÀNG): ánh xạ TKQC của mình ↔ catalog segment đối tác chia sẻ sang.
--    "accountId" cố ý là SCALAR không FK sang "Account" — theo đúng tiền lệ
--    "AutomationRuleAdAccount" (không thêm back-relation vào model Account cũ, tránh thêm
--    cạnh cascade vào một bảng legacy đông đúc).
CREATE TABLE IF NOT EXISTS "CpasPartnership" (
  "id"                   TEXT NOT NULL,
  "accountId"            TEXT NOT NULL,
  "segmentCatalogId"     TEXT NOT NULL,
  "retailerBusinessId"   TEXT,
  "retailerBusinessName" TEXT,
  "status"               "CpasPartnershipStatus" NOT NULL DEFAULT 'PENDING',
  "permittedTasks"       TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  "enabledCollabTerms"   TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  "utmSettings"          JSONB,
  "lastVerifiedAt"       TIMESTAMP(3),
  "lastError"            TEXT,
  "createdById"          TEXT,
  "createdAt"            TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"            TIMESTAMP(3) NOT NULL,
  CONSTRAINT "CpasPartnership_pkey" PRIMARY KEY ("id")
);

-- Một TKQC chỉ có đúng một bản ghi cho mỗi segment (chống khai báo trùng khi vừa có endpoint
-- admin vừa có người sửa tay bằng SQL).
CREATE UNIQUE INDEX IF NOT EXISTS "CpasPartnership_accountId_segmentCatalogId_key"
  ON "CpasPartnership" ("accountId", "segmentCatalogId");
CREATE INDEX IF NOT EXISTS "CpasPartnership_accountId_idx" ON "CpasPartnership" ("accountId");
CREATE INDEX IF NOT EXISTS "CpasPartnership_segmentCatalogId_idx" ON "CpasPartnership" ("segmentCatalogId");

ALTER TABLE "CpasPartnership"
  DROP CONSTRAINT IF EXISTS "CpasPartnership_segmentCatalogId_fkey";
ALTER TABLE "CpasPartnership"
  ADD CONSTRAINT "CpasPartnership_segmentCatalogId_fkey"
  FOREIGN KEY ("segmentCatalogId") REFERENCES "ProductCatalog"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- 3b) CHIỀU CHIA SẺ ĐI (vai NHÀ BÁN LẺ): segment mình cắt ra rồi chia cho Business nhãn hàng.
--     CỐ Ý là bảng RIÊNG chứ không phải cột `direction` trên bảng trên: hai chiều có khoá
--     chống trùng KHÁC NHAU — chiều nhận là (TKQC của mình, segment), chiều chia sẻ là
--     (segment, Business đối tác). Nếu gộp một bảng thì cột phân biệt buộc phải nullable, mà
--     Postgres coi mỗi NULL là một giá trị KHÁC NHAU nên UNIQUE mất hiệu lực đúng ở chiều có
--     NULL (hai TKQC cùng dùng một segment sẽ chèn được vô hạn bản ghi trùng). Cách vá là
--     partial unique index `WHERE direction=...`, nhưng Prisma không khai báo được thứ đó
--     trong schema → drift vĩnh viễn giữa schema và DB thật. Tách bảng thì cả hai cột khoá
--     đều NOT NULL và UNIQUE thật sự chặn được.
CREATE TABLE IF NOT EXISTS "CpasCatalogSegmentShare" (
  "id"                   TEXT NOT NULL,
  "segmentCatalogId"     TEXT NOT NULL,
  "partnerBusinessId"    TEXT NOT NULL,
  "partnerBusinessName"  TEXT,
  "status"               "CpasPartnershipStatus" NOT NULL DEFAULT 'PENDING',
  "permittedTasks"       TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  "enabledCollabTerms"   TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  "utmSettings"          JSONB,
  "lastVerifiedAt"       TIMESTAMP(3),
  "lastError"            TEXT,
  "createdById"          TEXT,
  "createdAt"            TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt"            TIMESTAMP(3) NOT NULL,
  CONSTRAINT "CpasCatalogSegmentShare_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "CpasCatalogSegmentShare_segmentCatalogId_partnerBusinessId_key"
  ON "CpasCatalogSegmentShare" ("segmentCatalogId", "partnerBusinessId");
CREATE INDEX IF NOT EXISTS "CpasCatalogSegmentShare_segmentCatalogId_idx"
  ON "CpasCatalogSegmentShare" ("segmentCatalogId");
CREATE INDEX IF NOT EXISTS "CpasCatalogSegmentShare_partnerBusinessId_idx"
  ON "CpasCatalogSegmentShare" ("partnerBusinessId");

ALTER TABLE "CpasCatalogSegmentShare"
  DROP CONSTRAINT IF EXISTS "CpasCatalogSegmentShare_segmentCatalogId_fkey";
ALTER TABLE "CpasCatalogSegmentShare"
  ADD CONSTRAINT "CpasCatalogSegmentShare_segmentCatalogId_fkey"
  FOREIGN KEY ("segmentCatalogId") REFERENCES "ProductCatalog"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- 4) Index lọc segment. Bảng ProductCatalog nhỏ (vài trăm hàng) nên CREATE INDEX thường là đủ
--    nhanh; nếu prod có nhiều hơn dự kiến thì bỏ dòng này ra chạy tay bằng
--    CREATE INDEX CONCURRENTLY (không chạy CONCURRENTLY trong file migration vì Prisma bọc
--    transaction, mà CONCURRENTLY không chạy được trong transaction).
CREATE INDEX IF NOT EXISTS "ProductCatalog_isCatalogSegment_idx"
  ON "ProductCatalog" ("isCatalogSegment");
