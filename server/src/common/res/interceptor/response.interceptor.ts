import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable, map } from 'rxjs';
import { ApiResponse } from '../dto/api-response.dto'; 

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, ApiResponse<T>> {
  intercept(context: ExecutionContext, next: CallHandler<T>): Observable<ApiResponse<T>> {
  return next.handle().pipe(
    map((data) => {
      if (data instanceof ApiResponse) return data;
      return ApiResponse.success(data);
    }),
  );
}

}
