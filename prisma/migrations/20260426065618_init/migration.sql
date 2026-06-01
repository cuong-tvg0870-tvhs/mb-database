/*
  Warnings:

  - You are about to drop the `CidContent` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterTable
ALTER TABLE "DriveFile" ADD COLUMN     "last_seen_at" TIMESTAMP(3);

-- DropTable
DROP TABLE "CidContent";
