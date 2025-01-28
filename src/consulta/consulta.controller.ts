import { Controller } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';
import { ConsultaService } from './consulta.service';

@Controller()
export class ConsultaController {
  constructor(private readonly consultaService: ConsultaService) {}

  @MessagePattern({ cmd: 'findOneNit' })
  findAll(@Payload('cc') cc: string[]) {
    console.log(this.consultaService.findAll(cc));
    return 'todos han sido buscados';
  }

  @MessagePattern({ cmd: 'findVALl' })
  findOne(@Payload('cc') cc: string) {
    console.log(this.consultaService.findOne(cc));
    return 'ha sido buscado';
  }
}
