import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class updatedTaskDto {
  @ApiProperty({ example: 'Buy groceries', description: 'Title of the task' })
  @IsNotEmpty({ message: 'Title is required' })
  @IsString({ message: 'Title must be a string' })
  title: string;

  @ApiPropertyOptional({ example: 'Milk, eggs, bread', description: 'Details about the task' })
  @IsOptional()
  @IsString({ message: 'Description must be a string' })
  description: string;
}
