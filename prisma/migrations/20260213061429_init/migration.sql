-- CreateEnum
CREATE TYPE "CreativeStatus" AS ENUM ('TEST', 'NEED_SPEND', 'SCALE_P1', 'SCALE_P2', 'REVIEW', 'KILL');

-- AlterTable
ALTER TABLE "Creative" ADD COLUMN     "performanceStatus" "CreativeStatus";
