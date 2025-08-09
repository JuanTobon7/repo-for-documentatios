import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { PrismaService } from 'prisma/prisma.service';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ResponseInterceptor } from './common/res/interceptor/response.interceptor'; 
import { GlobalExceptionFilter } from './common/res/filters/global-exception.filter'; 
import cookieParser from 'cookie-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: '*'
  })
  const prismaService = app.get(PrismaService);  
  await prismaService.enableShutdownHooks(app);
  app.use(cookieParser())
  app.useGlobalInterceptors(new ResponseInterceptor());
  app.useGlobalFilters(new GlobalExceptionFilter());
  app.setGlobalPrefix('api/v1');
  const config = new DocumentBuilder()
    .setTitle('Gestor de Tareas Personales')
    .setBasePath('api/v1')
    .setDescription('Documentación para prueba tecnica gestor de tareas personales')
    .setVersion('1.0')
    .build();
    app.useGlobalPipes(
      new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('swagger', app, document);
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
  console.log(`Application is running on: ${await app.getUrl()}`);
}
bootstrap();
