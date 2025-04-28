-- CreateTable
CREATE TABLE "TrainerSchedulingRule" (
    "id" TEXT NOT NULL,
    "trainerId" TEXT NOT NULL,
    "maxSessionsPerDay" INTEGER NOT NULL,
    "daysOff" "Day"[],
    "overlapAllowed" BOOLEAN NOT NULL,

    CONSTRAINT "TrainerSchedulingRule_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "TrainerSchedulingRule_trainerId_key" ON "TrainerSchedulingRule"("trainerId");

-- AddForeignKey
ALTER TABLE "TrainerSchedulingRule" ADD CONSTRAINT "TrainerSchedulingRule_trainerId_fkey" FOREIGN KEY ("trainerId") REFERENCES "Trainer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
