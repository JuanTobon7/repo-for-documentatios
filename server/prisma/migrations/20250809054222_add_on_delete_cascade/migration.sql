-- DropForeignKey
ALTER TABLE "public"."DailyTask" DROP CONSTRAINT "DailyTask_taskId_fkey";

-- AddForeignKey
ALTER TABLE "public"."DailyTask" ADD CONSTRAINT "DailyTask_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES "public"."Task"("id") ON DELETE CASCADE ON UPDATE CASCADE;
