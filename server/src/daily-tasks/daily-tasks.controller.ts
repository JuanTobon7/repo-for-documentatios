import { BadRequestException, Body, Controller, HttpCode, Param, Put, Query, UseGuards } from '@nestjs/common';
import { DailyTasksService } from './daily-tasks.service';
import { ApiBadRequestResponse, ApiBearerAuth, ApiExtraModels, ApiOkResponse, ApiQuery, ApiTags, ApiUnauthorizedResponse, getSchemaPath } from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/common/conf/jwt.guard';

@ApiTags('Daily Tasks')
@ApiBearerAuth()
@Controller('tasks/:taskId/daily-tasks')
export class DailyTasksController {
    constructor(private readonly dailyTaskService: DailyTasksService){}
        
    @ApiOkResponse({
        description: 'Successful Update of DailyTask',
        example: 'Resource Updated'
    })
    @HttpCode(201)
    @ApiUnauthorizedResponse({ description: 'Unauthorized - JWT is invalid or missing' })
    @ApiBadRequestResponse({ description: 'Bad Request - Invalid input data'})
    @UseGuards(JwtAuthGuard)
    @ApiQuery({ name: 'date', required: true, type: String, description: 'Filter tasks by creation date (ISO format)' })
    @Put(':date')
    async updateDailyTask(@Param('taskId') taskId: string, @Param('date') date: string){
        if(!taskId) throw new BadRequestException('taskId is required')
        if(!date) throw new BadRequestException('Fecha requerida')
        await this.dailyTaskService.updateDailyTask(taskId,new Date(date));        
        return 'Resource Updated';
    }    
}
