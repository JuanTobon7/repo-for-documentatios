import { SetMetadata } from '@nestjs/common';

export const StatusTask = (...args: string[]) => SetMetadata('status-task', args);

export enum StatusTaskEnum {
  PENDING = 'PENDING',
  DONE = 'DONE',
}