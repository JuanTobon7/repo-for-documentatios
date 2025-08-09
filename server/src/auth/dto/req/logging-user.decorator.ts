import { SetMetadata } from '@nestjs/common';
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export const LoggingUser = (...args: string[]) => SetMetadata('logging-user', args);

export class LoggingUserDto {
    @ApiProperty({example: 'john@example.com', description: 'Email of the user for login', required: true})
    @IsNotEmpty({message: 'Email is required'})
    @IsEmail({},{message: 'Email must be a valid email address'})
    email: string
    @ApiProperty({example: 'StrongPassword123!',description:'Password of the user for login', required: true})
    @IsNotEmpty({message: 'Password is required'})    
    password: string
}