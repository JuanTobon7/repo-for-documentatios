import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  Post,
  Put,
  Query,
  Req,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { ArrayTasksDto } from './dto/array-tasks.decorator';
import { CreateTasksDto } from './dto/create-tasks.decorator';
import { ApiBearerAuth, ApiOkResponse, ApiTags, ApiUnauthorizedResponse, getSchemaPath, ApiExtraModels, ApiQuery } from '@nestjs/swagger';
import { ApiResponse } from 'src/common/res/dto/api-response.dto';
import { TasksService } from './tasks.service';
import type { Request } from 'express';
import { JwtAuthGuard } from 'src/common/conf/jwt.guard';
import { updatedTaskDto } from './dto/update-tasks.decorator';

@ApiTags('Tasks')
@ApiBearerAuth()
@Controller('tasks')
export class TasksController {
  constructor(private readonly taskService: TasksService) {}

  @ApiExtraModels(ApiResponse, CreateTasksDto)
  @ApiOkResponse({
    description: 'Successful Creation of Task',
    schema: {
        allOf: [
        { $ref: getSchemaPath(ApiResponse) },
        {
            properties: {
            data: { $ref: getSchemaPath(CreateTasksDto) },
            },
        },
        ],
    },
  })
  @HttpCode(201)
  @ApiUnauthorizedResponse({ description: 'Unauthorized - JWT is invalid or missing' })
  @UseGuards(JwtAuthGuard)
  @Post()
  async createTask(@Body() dto: CreateTasksDto, @Req() request: Request) {
    const payload = request.user;
    if(!payload) throw new UnauthorizedException('No logueado');
    const userId = payload['userId'] as string;
    const response = await this.taskService.createTask(dto, userId);
    return ApiResponse.created(response);
  }

  @ApiExtraModels(ApiResponse, ArrayTasksDto)
  @ApiOkResponse({
    description: 'Task list retrieved successfully',
    schema: {
      allOf: [
        { $ref: getSchemaPath(ApiResponse) },
        {
          properties: {
            data: { $ref: getSchemaPath(ArrayTasksDto) },
          },
        },
      ],
    },
  })
  @ApiUnauthorizedResponse({description: 'Unauthorized - JWT is missing or invalid'})
  @UseGuards(JwtAuthGuard)
  @ApiQuery({ name: 'date', required: true, type: String, description: 'Filter tasks by creation date (ISO format)' })
  @ApiQuery({ name: 'status', required: false, type: String, description: 'Filter tasks by status (e.g., "pending", "done")' })

  @Get()
  async getListTasks(@Req() request: Request,@Query() query: any,@Query('date') date: string, @Query('status') status?: string) {
    const payload = request.user;
    console.log(query);
    if(!payload) throw new UnauthorizedException('No logueado');
    const userId = payload['userId'] as string;
    if(!date) throw new BadRequestException("No fecha prevista");    
    return await this.taskService.getListTasks(userId,date,status);
  }
  @ApiExtraModels(ApiResponse, CreateTasksDto)
  @ApiOkResponse({
    description: 'Task updated successfully',
    schema: {
      allOf: [
        { $ref: getSchemaPath(ApiResponse) },
        {
          properties: {
            data: { $ref: getSchemaPath(CreateTasksDto) },
          },
        },
      ],
    },
  })
  @ApiUnauthorizedResponse({description: 'Unauthorized - JWT is missing or invalid'})
  @UseGuards(JwtAuthGuard)
  @Put(':id')
  async updateTask(
    @Param('id') id: string,
    @Body() dto: updatedTaskDto,
    @Req() request: Request,
  ) {
    const payload = request.user;
    if(!payload) throw new UnauthorizedException('No logueado');
    const userId = payload['userId'] as string;
    return await this.taskService.updateTask(id, dto, userId);
  }

  @ApiOkResponse({
    description: 'Task deleted successfully',
    example: "Resource deleted"
  })
  @ApiUnauthorizedResponse({description: 'Unauthorized - JWT is missing or invalid'})
  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async deleteTask(@Param('id') id: string, @Req() request: Request) {
      const payload = request.user;
      if(!payload) throw new UnauthorizedException('No logueado');
      const userId = payload['userId'] as string;
      console.log('incomming id: ',id);
      await this.taskService.deleteTask(id,userId);
      return ApiResponse.deleted()
    }
}
