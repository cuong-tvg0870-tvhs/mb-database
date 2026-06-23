-- CreateTable
CREATE TABLE "HelpAiApiKey" (
    "id" TEXT NOT NULL,
    "provider" TEXT NOT NULL DEFAULT 'gemini',
    "label" TEXT,
    "apiKey" TEXT NOT NULL,
    "keyHash" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "blockedUntil" TIMESTAMP(3),
    "blockedReason" TEXT,
    "quotaResetAt" TIMESTAMP(3),
    "requestsUsed" INTEGER NOT NULL DEFAULT 0,
    "tokensUsed" INTEGER NOT NULL DEFAULT 0,
    "usageWindowStartedAt" TIMESTAMP(3),
    "usageWindowResetAt" TIMESTAMP(3),
    "dailyRequestLimit" INTEGER,
    "dailyTokenLimit" INTEGER,
    "lastUsedAt" TIMESTAMP(3),
    "lastSuccessAt" TIMESTAMP(3),
    "lastFailureAt" TIMESTAMP(3),
    "lastErrorCode" TEXT,
    "lastErrorMessage" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "HelpAiApiKey_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "HelpAiApiKey_keyHash_key" ON "HelpAiApiKey"("keyHash");

-- CreateIndex
CREATE INDEX "HelpAiApiKey_provider_status_blockedUntil_idx" ON "HelpAiApiKey"("provider", "status", "blockedUntil");

-- CreateIndex
CREATE INDEX "HelpAiApiKey_usageWindowResetAt_idx" ON "HelpAiApiKey"("usageWindowResetAt");
