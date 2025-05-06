-- DropForeignKey
ALTER TABLE "Delegate" DROP CONSTRAINT "Delegate_sessionId_fkey";

-- AlterTable
ALTER TABLE "Delegate" ADD COLUMN     "clientId" TEXT;

-- AddForeignKey
ALTER TABLE "Delegate" ADD CONSTRAINT "Delegate_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Delegate" ADD CONSTRAINT "Delegate_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "TrainingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;
