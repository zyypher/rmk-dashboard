/*
  Warnings:

  - You are about to drop the column `languages` on the `Course` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Course" DROP COLUMN "languages";

-- CreateTable
CREATE TABLE "_CourseLanguages" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_CourseLanguages_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE INDEX "_CourseLanguages_B_index" ON "_CourseLanguages"("B");

-- AddForeignKey
ALTER TABLE "_CourseLanguages" ADD CONSTRAINT "_CourseLanguages_A_fkey" FOREIGN KEY ("A") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CourseLanguages" ADD CONSTRAINT "_CourseLanguages_B_fkey" FOREIGN KEY ("B") REFERENCES "Language"("id") ON DELETE CASCADE ON UPDATE CASCADE;
