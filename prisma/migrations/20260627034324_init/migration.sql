-- CreateEnum
CREATE TYPE "MessageTemplateChannel" AS ENUM ('MESSENGER', 'WHATSAPP');

-- CreateTable
CREATE TABLE "MessageTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "channel" "MessageTemplateChannel" NOT NULL,
    "fanpageId" TEXT NOT NULL,
    "spec" JSONB NOT NULL,
    "source" TEXT,
    "sourceHash" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MessageTemplate_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "MessageTemplate_fanpageId_channel_idx" ON "MessageTemplate"("fanpageId", "channel");

-- CreateIndex
CREATE UNIQUE INDEX "MessageTemplate_fanpageId_channel_sourceHash_key" ON "MessageTemplate"("fanpageId", "channel", "sourceHash");

-- AddForeignKey
ALTER TABLE "MessageTemplate" ADD CONSTRAINT "MessageTemplate_fanpageId_fkey" FOREIGN KEY ("fanpageId") REFERENCES "Fanpage"("id") ON DELETE CASCADE ON UPDATE CASCADE;
