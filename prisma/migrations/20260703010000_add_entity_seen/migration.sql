-- Bảng đánh dấu "đã xem" theo từng user cho MỌI entity (badge "Mới" ở danh sách).
-- Đa hình: (entityType, entityId, userId). Không có dòng = user chưa mở entity đó.
-- Không FK (entityId đa hình) → chấp nhận orphan khi hard-delete (nhỏ, vô hại).
-- Additive & non-breaking (type + bảng mới hoàn toàn). Badge chỉ tính entity tạo
-- sau mốc rollout (env SEEN_NEW_SINCE ở mb-ads) nên bảng rỗng lúc đầu là đúng.

-- CreateEnum
CREATE TYPE "SeenEntityType" AS ENUM ('CAMPAIGN', 'ADSET', 'AD', 'CREATIVE');

-- CreateTable
CREATE TABLE "EntitySeen" (
    "entityType" "SeenEntityType" NOT NULL,
    "entityId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "seenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EntitySeen_pkey" PRIMARY KEY ("entityType","entityId","userId")
);

-- CreateIndex: tra cứu các entity 1 user đã xem theo loại (annotate danh sách).
CREATE INDEX "EntitySeen_userId_entityType_idx" ON "EntitySeen"("userId", "entityType");
