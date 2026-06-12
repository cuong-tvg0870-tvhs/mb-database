-- AlterTable
ALTER TABLE "Contribution" ADD COLUMN     "expectedProcessedAt" TIMESTAMP(3),
ADD COLUMN     "userFeedback" JSONB;
