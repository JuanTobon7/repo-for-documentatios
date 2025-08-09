import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { ApiOkResponse } from '@nestjs/swagger';
import { ApiResponse } from './common/res/dto/api-response.dto';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @ApiOkResponse({
     description: 'Returns a greeting message',
    schema: {
      type: 'string',
      example: ApiResponse.success(null,'Hello World!'),
    },
  })
  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
}
