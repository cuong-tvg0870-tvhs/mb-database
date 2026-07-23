-- Mục đích: bảng lưu token khôi phục mật khẩu cho luồng "Quên mật khẩu" ở màn
-- đăng nhập. User nhập email → hệ thống tạo 1 token, gửi LINK chứa token qua
-- email → user mở link đặt lại mật khẩu mới.
--
-- Bảo mật: cột `tokenHash` chỉ lưu SHA-256 của token thô (token thô KHÔNG bao
-- giờ chạm DB, chỉ nằm trong link email). Token dùng MỘT LẦN (`usedAt`) và hết
-- hạn ngắn (`expiresAt`, hiện đặt 15 phút ở tầng ứng dụng). ON DELETE CASCADE để
-- xoá user thì token con dọn theo.
--
-- Back-compat / additive thuần: chỉ TẠO bảng mới + index, KHÔNG đụng bảng cũ
-- (kể cả "User"). mb-ads/mb-batch bản cũ vẫn đọc-ghi bình thường trong lúc
-- rolling deploy.
-- Rollout: apply lúc nào cũng được, không cần dừng writer. LƯU Ý: backend mb-ads
-- ghi vào bảng này khi user bấm "Quên mật khẩu" → phải apply migration TRƯỚC/CÙNG
-- LÚC deploy mb-ads mới, nếu không endpoint sẽ lỗi.
-- KHÔNG apply migration tự động từ workspace này; người vận hành deploy riêng.

-- CreateTable
CREATE TABLE "PasswordResetToken" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PasswordResetToken_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PasswordResetToken_tokenHash_key" ON "PasswordResetToken"("tokenHash");

-- CreateIndex
CREATE INDEX "PasswordResetToken_userId_idx" ON "PasswordResetToken"("userId");

-- CreateIndex
CREATE INDEX "PasswordResetToken_expiresAt_idx" ON "PasswordResetToken"("expiresAt");

-- AddForeignKey
ALTER TABLE "PasswordResetToken" ADD CONSTRAINT "PasswordResetToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
