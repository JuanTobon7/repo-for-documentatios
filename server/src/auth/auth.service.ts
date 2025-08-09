import { ConflictException, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { CreateUserDto } from './dto/req/create-user.decorator'; 
import { PrismaService } from 'prisma/prisma.service'; 
import * as bcrypt from 'bcrypt';
import { UserResponseDto } from './dto/res/user-response.decorator';
import { LoggingUserDto } from './dto/req/logging-user.decorator';
import { JwtService } from '@nestjs/jwt';
import { JwtStuct } from 'src/common/conf/jwt.struct';
@Injectable()
export class AuthService {
    constructor(private readonly prismaService: PrismaService, private readonly jwtService: JwtService){}

    private async EncryptPassword(password: string): Promise<string> {
        return await bcrypt.hash(password,10);
    }

    private async ComparePassword(password: string, hash: string): Promise<boolean> {
        return await bcrypt.compare(password, hash);
    }

    async createUser(dto: CreateUserDto): Promise<UserResponseDto>{
        const encryptedPassword = await this.EncryptPassword(dto.password)
        if(await this.prismaService.user.findUnique({where: {email: dto.email}}))  throw new ConflictException('User already exists with this email')
        const user = await this.prismaService.user.create({data:{
            first_name: dto.firstName,
            last_name: dto.lastName,
            email: dto.email,
            password: encryptedPassword
        }})
        if(!user) throw new NotFoundException('User not created')
        const userResponse = new UserResponseDto();
        userResponse.email = user.email;
        userResponse.firstName = user.first_name;
        userResponse.lastName = user.last_name;
        return userResponse;
    }
    async logIn(dto: LoggingUserDto){
        const user = await this.prismaService.user.findUnique({where: {email: dto.email}})
        if(!user) throw new NotFoundException(`User not found with email: ${dto.email}`)
        const isPasswordValid = await this.ComparePassword(dto.password, user.password);
        if(!isPasswordValid) throw new UnauthorizedException('Invalid Password');
        return this.jwtService.sign({userId: user.id, email: user.email} as JwtStuct)

    }
}
