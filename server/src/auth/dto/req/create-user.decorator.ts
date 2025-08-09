import { SetMetadata } from '@nestjs/common';
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, IsStrongPassword } from 'class-validator';

export const CreateUser = (...args: string[]) => SetMetadata('create-user', args);

export class CreateUserDto {
    @ApiProperty({example: 'John',description: 'First name of the user', required: true})
    @IsNotEmpty({message: 'First name is required'})
    @IsString({message: 'Fisrt name must be a string'})
    firstName: string
    @ApiProperty({example: 'Doe',description: 'Last name of the user', required: true})
    @IsNotEmpty({message: 'Last name is required'})
    @IsString({message: 'Last name must be a string'})
    lastName: string
    @ApiProperty({example: 'john@example.com', description: 'Email of the user', required: true})
    @IsNotEmpty({message: 'Email is required'})
    @IsEmail({},{message: 'Email must be a valid email address'})
    email: string
    @ApiProperty({example: 'StrongPassword123!', description: 'Password of the user', required: true})
    @IsNotEmpty({message: 'Password is required'})
    @IsStrongPassword({
        minLength: 4, 
        minLowercase: 1, 
        minUppercase: 1, 
        minNumbers: 1, 
        minSymbols: 1}, 
        { message:
      'Password must be at least 4 characters long and include at least one lowercase letter, one uppercase letter, one number, and one special symbol.',})
    password: string
}