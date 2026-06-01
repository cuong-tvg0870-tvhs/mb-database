-- CreateEnum
CREATE TYPE "FolderStatus" AS ENUM ('ACTIVE', 'DEACTIVE');

-- AlterTable
ALTER TABLE "CreativeFolder" ADD COLUMN     "status" "FolderStatus" NOT NULL DEFAULT 'ACTIVE';
