-- CreateTable
CREATE TABLE "PublishHistory" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "steps" JSONB NOT NULL,
    "error" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PublishHistory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "PublishHistory_campaignId_idx" ON "PublishHistory"("campaignId");

-- AddForeignKey
ALTER TABLE "PublishHistory" ADD CONSTRAINT "PublishHistory_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "SystemCampaign"("id") ON DELETE CASCADE ON UPDATE CASCADE;
