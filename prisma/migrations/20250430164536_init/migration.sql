/*
  Warnings:

  - You are about to drop the column `capacity` on the `Location` table. All the data in the column will be lost.
  - You are about to drop the column `type` on the `Location` table. All the data in the column will be lost.
  - You are about to drop the column `type` on the `Room` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Location" DROP COLUMN "capacity",
DROP COLUMN "type",
ADD COLUMN     "isOnline" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Room" DROP COLUMN "type";

-- DropEnum
DROP TYPE "RoomType";
