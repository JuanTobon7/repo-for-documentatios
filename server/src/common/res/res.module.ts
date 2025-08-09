import { Global, Module } from "@nestjs/common";

import { GlobalExceptionFilter } from "./filters/global-exception.filter"; 
import { ResponseInterceptor } from "./interceptor/response.interceptor";

@Global()
@Module({
    imports: [GlobalExceptionFilter, ResponseInterceptor],
    providers: [GlobalExceptionFilter, ResponseInterceptor],
    exports: [GlobalExceptionFilter, ResponseInterceptor],
})

export class ResModule{}