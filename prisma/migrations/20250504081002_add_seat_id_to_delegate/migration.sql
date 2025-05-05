/*
  Warnings:

  - Added the required column `seatId` to the `Delegate` table without a default value. This is not possible if the table is not empty.
  - Made the column `photoUrl` on table `Delegate` required. This step will fail if there are existing NULL values in that column.
  - Changed the type of `status` on the `Delegate` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Delegate" ADD COLUMN     "seatId" TEXT NOT NULL,
ALTER COLUMN "photoUrl" SET NOT NULL,
DROP COLUMN "status",
ADD COLUMN     "status" TEXT NOT NULL;
