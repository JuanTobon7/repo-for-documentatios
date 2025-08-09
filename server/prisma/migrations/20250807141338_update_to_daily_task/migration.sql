/*
  Warnings:

  - You are about to drop the column `createdAt` on the `Task` table. All the data in the column will be lost.
  - You are about to drop the column `status` on the `Task` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Task` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "public"."Task" DROP COLUMN "createdAt",
DROP COLUMN "status",
DROP COLUMN "updatedAt";

-- CreateTable
CREATE TABLE "public"."DailyTask" (
    "id" UUID NOT NULL,
    "status" VARCHAR(50) NOT NULL,
    "date" TIMESTAMP(6) NOT NULL,
    "taskId" UUID NOT NULL,

    CONSTRAINT "DailyTask_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "public"."DailyTask" ADD CONSTRAINT "DailyTask_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "public"."Task"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
