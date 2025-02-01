import { Controller } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';
import { ConsultaService } from './consulta.service';
import { CONSULTANIT_CMD } from 'src/config/env.config';

@Controller()
export class ConsultaController {
  constructor(private readonly consultaService: ConsultaService) {}
  @MessagePattern({ cmd: CONSULTANIT_CMD })
  findOne(@Payload('cc') cc: string) {
    const data = this.consultaService.findOne(cc);
    return data;
  }
}
