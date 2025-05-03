/*
  Warnings:

  - You are about to drop the column `trainerId` on the `Course` table. All the data in the column will be lost.
  - You are about to drop the column `address` on the `Location` table. All the data in the column will be lost.
  - You are about to drop the column `isOnline` on the `Location` table. All the data in the column will be lost.
  - Added the required column `deliveryApproach` to the `Location` table without a default value. This is not possible if the table is not empty.
  - Added the required column `emirate` to the `Location` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Course" DROP CONSTRAINT "Course_trainerId_fkey";

-- AlterTable
ALTER TABLE "Course" DROP COLUMN "trainerId";

-- AlterTable
ALTER TABLE "Location" DROP COLUMN "address",
DROP COLUMN "isOnline",
ADD COLUMN     "deliveryApproach" TEXT NOT NULL,
ADD COLUMN     "emirate" TEXT NOT NULL,
ADD COLUMN     "locationType" TEXT,
ADD COLUMN     "zoomLink" TEXT;

-- AlterTable
ALTER TABLE "Trainer" ADD COLUMN     "dailyTimeSlots" JSONB;

-- CreateTable
CREATE TABLE "_TrainerCourses" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_TrainerCourses_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE INDEX "_TrainerCourses_B_index" ON "_TrainerCourses"("B");

-- AddForeignKey
ALTER TABLE "_TrainerCourses" ADD CONSTRAINT "_TrainerCourses_A_fkey" FOREIGN KEY ("A") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TrainerCourses" ADD CONSTRAINT "_TrainerCourses_B_fkey" FOREIGN KEY ("B") REFERENCES "Trainer"("id") ON DELETE CASCADE ON UPDATE CASCADE;
