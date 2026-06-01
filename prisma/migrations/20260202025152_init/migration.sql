/*
  Warnings:

  - You are about to drop the column `intervalSec` on the `Planning` table. All the data in the column will be lost.
  - You are about to drop the column `payload` on the `Planning` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Planning` table. All the data in the column will be lost.
  - Added the required column `config` to the `Planning` table without a default value. This is not possible if the table is not empty.
  - Added the required column `createdById` to the `Planning` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `Planning` table without a default value. This is not possible if the table is not empty.
  - Added the required column `schedule` to the `Planning` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Planning" DROP COLUMN "intervalSec",
DROP COLUMN "payload",
DROP COLUMN "userId",
ADD COLUMN     "config" JSONB NOT NULL,
ADD COLUMN     "createdById" TEXT NOT NULL,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "name" TEXT NOT NULL,
ADD COLUMN     "schedule" JSONB NOT NULL,
ALTER COLUMN "nextRunAt" DROP NOT NULL;
