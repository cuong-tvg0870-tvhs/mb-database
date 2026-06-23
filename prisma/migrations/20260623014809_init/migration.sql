-- CreateTable
CREATE TABLE "HelpChatSession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "HelpChatSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HelpChatMessage" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HelpChatMessage_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "HelpChatSession_userId_deletedAt_idx" ON "HelpChatSession"("userId", "deletedAt");

-- CreateIndex
CREATE INDEX "HelpChatSession_updatedAt_idx" ON "HelpChatSession"("updatedAt");

-- CreateIndex
CREATE INDEX "HelpChatMessage_sessionId_createdAt_idx" ON "HelpChatMessage"("sessionId", "createdAt");

-- AddForeignKey
ALTER TABLE "HelpChatSession" ADD CONSTRAINT "HelpChatSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HelpChatMessage" ADD CONSTRAINT "HelpChatMessage_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "HelpChatSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;
