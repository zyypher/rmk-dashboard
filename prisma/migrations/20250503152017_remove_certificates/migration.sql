/*
  Warnings:

  - You are about to drop the column `company` on the `Client` table. All the data in the column will be lost.
  - You are about to drop the `Certificate` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Certificate" DROP CONSTRAINT "Certificate_clientId_fkey";

-- DropForeignKey
ALTER TABLE "Certificate" DROP CONSTRAINT "Certificate_courseId_fkey";

-- AlterTable
ALTER TABLE "Client" DROP COLUMN "company",
ADD COLUMN     "contactPersonName" TEXT,
ADD COLUMN     "tradeLicenseNumber" TEXT;

-- DropTable
DROP TABLE "Certificate";
