-- CreateTable
CREATE TABLE "HelpAiKnowledgeSnapshot" (
    "id" TEXT NOT NULL,
    "sourceHash" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'READY',
    "generatedBy" TEXT NOT NULL DEFAULT 'mb-batch',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "HelpAiKnowledgeSnapshot_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "HelpAiKnowledgeSnapshot_sourceHash_key" ON "HelpAiKnowledgeSnapshot"("sourceHash");
