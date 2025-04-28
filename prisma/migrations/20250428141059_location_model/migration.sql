/*
  Warnings:

  - Added the required column `capacity` to the `Location` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Location` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Location" ADD COLUMN     "capacity" INTEGER NOT NULL,
ADD COLUMN     "type" "RoomType" NOT NULL;
