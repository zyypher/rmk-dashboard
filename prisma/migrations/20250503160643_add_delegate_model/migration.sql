/*
  Warnings:

  - You are about to drop the column `status` on the `TrainingSession` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "DelegateStatus" AS ENUM ('CONFIRMED', 'NOT_CONFIRMED');

-- AlterTable
ALTER TABLE "TrainingSession" DROP COLUMN "status";

-- CreateTable
CREATE TABLE "Delegate" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "emiratesId" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "isCorporate" BOOLEAN NOT NULL,
    "photoUrl" TEXT,
    "status" "DelegateStatus" NOT NULL DEFAULT 'NOT_CONFIRMED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Delegate_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Delegate" ADD CONSTRAINT "Delegate_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "TrainingSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
