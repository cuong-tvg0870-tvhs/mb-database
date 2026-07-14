-- Mẫu quy tắc "lên lịch theo điều kiện" (cuốn chiếu).
-- Lưu lại ĐIỀU KIỆN + cấu hình tăng ngân sách (config JSON) để user áp nhanh cho
-- campaign khác, khỏi nhập lại. KHÔNG gắn tài khoản/chiến dịch/nhóm và KHÔNG kèm lịch
-- quét — chỉ phần tái dùng được. isShared=true → cả team dùng chung.
-- Additive: TẠO BẢNG MỚI, không đụng dữ liệu/hành vi cũ. Chưa apply prod tự động.

-- CreateTable
CREATE TABLE "campaign_rule_template" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "config" JSONB NOT NULL,
    "isShared" BOOLEAN NOT NULL DEFAULT false,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "campaign_rule_template_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "campaign_rule_template_createdById_updatedAt_idx" ON "campaign_rule_template"("createdById", "updatedAt" DESC);

-- CreateIndex
CREATE INDEX "campaign_rule_template_isShared_updatedAt_idx" ON "campaign_rule_template"("isShared", "updatedAt" DESC);
