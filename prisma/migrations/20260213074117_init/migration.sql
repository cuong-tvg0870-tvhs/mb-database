/*
  Warnings:

  - The values [KILL] on the enum `CreativeStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "CreativeStatus_new" AS ENUM ('TEST', 'NEED_SPEND', 'SCALE_P1', 'SCALE_P2', 'REVIEW', 'OFF');
ALTER TABLE "Creative" ALTER COLUMN "performanceStatus" TYPE "CreativeStatus_new" USING ("performanceStatus"::text::"CreativeStatus_new");
ALTER TYPE "CreativeStatus" RENAME TO "CreativeStatus_old";
ALTER TYPE "CreativeStatus_new" RENAME TO "CreativeStatus";
DROP TYPE "public"."CreativeStatus_old";
COMMIT;
