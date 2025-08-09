import { BadRequestException, Injectable } from '@nestjs/common';
import { DailyTask } from '@prisma/client';
import { PrismaService } from 'prisma/prisma.service';
import { StatusTaskEnum } from './dto/enum/status-task/status-task.decorator';

@Injectable()
export class DailyTasksService {
    constructor(private readonly prismaService: PrismaService){}

    private async existsDailyTask(taskId: string, date: Date): Promise<DailyTask | null>{
        try {
          return await this.prismaService.dailyTask.findFirst({
                where: {
                    taskId: taskId,
                    date: date
                }
            })        
        } catch (error) {
            return null;
        }
    }

    private async delete(id: string, taskId: string, date: Date): Promise<void>{
        await this.prismaService.dailyTask.delete({
            where: {taskId: taskId, date: new Date(date), id: id},
        })        
    }

    async updateDailyTask(taskId: string, date: Date): Promise<void>{
        if(!taskId) throw new BadRequestException('taskId is required');
        try {
            const existingDailyTask = await this.existsDailyTask(taskId,date)
            if(existingDailyTask){
                await this.delete(existingDailyTask.id,taskId, date);
                return;
            }
            await this.prismaService.dailyTask.create({
                data: {
                    status: StatusTaskEnum.DONE,
                    taskId: taskId,
                    date: date
                }
            });
        } catch (error) {
            throw error;
        }

    }
}
