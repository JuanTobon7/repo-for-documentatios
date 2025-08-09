import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class ArrayTasksDto {
  @ApiProperty({ examples: ['Buy groceries'], description: 'Title of the task' })
  @IsNotEmpty({ message: 'Title is required' })
  @IsString({ message: 'Title must be a string' })
  title: string;

  @ApiPropertyOptional({ examples: ['Milk, eggs, bread'], description: 'Details about the task' })
  @IsOptional()
  @IsString({ message: 'Description must be a string' })
  description: string;

  @ApiProperty({ examples: ['2025-08-06T12:00:00'], description: 'Creation date of the task' })
  @IsNotEmpty({ message: 'The Date is required' })
  createdAt: Date;
}
