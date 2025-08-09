import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';
import { CreateTasksDto } from './dto/create-tasks.decorator'; 
import { Prisma, Task } from '@prisma/client';
import { updatedTaskDto } from './dto/update-tasks.decorator';
import { StatusTaskEnum } from 'src/daily-tasks/dto/enum/status-task/status-task.decorator';

@Injectable()
export class TasksService {
    constructor(private readonly prismaService: PrismaService){}

    private hanldeStartOfDay(date: Date):Date{
        const startOfDay = new Date(date);
        startOfDay.setHours(0, 0, 0, 0);     
        return startOfDay
    }

    private handleEndOfDay(date: Date):Date{
            const end = new Date(date);
            end.setHours(0,0,0,0)
            end.setDate(end.getDate() + 1);
            return end;
    }

    private async getByDone(userId: string, date: Date) {   
            
            return await this.prismaService.task.findMany({
            where: {
                userId: userId,
                createdAt: {lte: date},
                dailyTasks: {
                    some: {
                        status: {
                            equals: StatusTaskEnum.DONE
                        }
                    }
                }
            },
            include: {
                dailyTasks: {
                    where: {date: {
                        gte: this.hanldeStartOfDay(date),
                        lte: this.handleEndOfDay(date)
                    }}
                }
            },
            orderBy: { createdAt: 'desc' },         
            });
        }    

    private async getExludeDone(userId: string, date: Date){
         return await this.prismaService.task.findMany({
            where: {
                userId: userId,
                createdAt: {lte: date},
                dailyTasks: {
                    none: {}
                }
            },
            include: {
                dailyTasks: {
                    where: {date: {
                        gte: this.hanldeStartOfDay(date),
                        lte: this.handleEndOfDay(date)
                    }}
                }
            },
            orderBy: { createdAt: 'desc' },         
            });
    }

    private async getAll(userId: string, date: Date){

        return await this.prismaService.task.findMany({
            where: {
            userId: userId,
            createdAt: { lte: date },
            },
            include: {
            dailyTasks: {
                where: {date: {
                        gte: this.hanldeStartOfDay(date),
                        lte: this.handleEndOfDay(date)
                    }}
            }
            },
            orderBy: { createdAt: 'desc' },
        });
    }

    private async getByStatus(userId: string, date: Date,status: string | undefined): Promise<Task[]>{
        switch(status){
            case StatusTaskEnum.DONE:
                return await this.getByDone(userId,date);
            case StatusTaskEnum.PENDING:
                return await this.getExludeDone(userId, date);
            default:
                return await this.getAll(userId,date);
        }
    }

    async createTask(dto: CreateTasksDto, userId: string): Promise<Task>{
        if(!userId) throw new NotFoundException('User Id is required')
        const date = new Date(dto.createdAt);
        date.setUTCHours(0,0,0,0);
        const task = await this.prismaService.task.create({
            data: {
                userId: userId,
                title: dto.title,
                description: dto.description,
                createdAt: date,
            }
        });
        return task;
    }

    async getListTasks(userId: string, dateStr: string, status: string | undefined): Promise<Task[]> {
        if (!userId) throw new NotFoundException('User Id is required');


        let date = new Date(dateStr);
        if (dateStr) {
            date.setDate(date.getDate());
        }        
        
        const tasks = await this.getByStatus(userId,date,status);

        if (!tasks || tasks.length === 0) {
            throw new NotFoundException(`No tasks found for this user in date ${dateStr}`);
        }

        return tasks;
    }


    async updateTask(id: string, dto: updatedTaskDto, userId: string): Promise<Task>{
        if(!userId) throw new NotFoundException('User Id is required');
        const task = await this.prismaService.task.findUnique({where: {id: id, userId: userId}});
        if(!task) throw new NotFoundException(`Task with ID ${id} not found for user ${userId}`);
        
        const updatedTask = await this.prismaService.task.update({
            where: {id: id, userId: userId},
            data: {
                title: dto.title,
                description: dto.description,
            }
        });
        return updatedTask;
    }

    async deleteTask(id: string, userId: string): Promise<void>{
        if(!id) throw new NotFoundException('Task Id is required');
        console.log('id: ',id)
        const splitedId = id.split(',')
        const task = await this.prismaService.task.findMany({where: {id: {in: splitedId}, userId: userId}});
        if(!task) throw new NotFoundException(`Task with Id ${id} not found`)
        await this.prismaService.task.deleteMany({where:{
            id: {in: splitedId}
        }})
    }
}
