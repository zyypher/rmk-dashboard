/*
  Warnings:

  - You are about to drop the column `overlapAllowed` on the `TrainerSchedulingRule` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "TrainerSchedulingRule" DROP COLUMN "overlapAllowed",
ADD COLUMN     "allowOverlap" BOOLEAN NOT NULL DEFAULT false;
