/*
  Warnings:

  - You are about to drop the column `isOnline` on the `Room` table. All the data in the column will be lost.
  - Added the required column `type` to the `Room` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "RoomType" AS ENUM ('ONLINE', 'OFFLINE');

-- AlterTable
ALTER TABLE "Room" DROP COLUMN "isOnline",
ADD COLUMN     "notes" TEXT,
ADD COLUMN     "type" "RoomType" NOT NULL;
