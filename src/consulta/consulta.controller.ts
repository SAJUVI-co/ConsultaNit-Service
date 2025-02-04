import { Controller, Logger } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';
import { ConsultaService } from './consulta.service';
import {
  CONSULTANIT_CMD_NIT,
  CONSULTANIT_CMD_NITS,
} from 'src/config/env.config';
import { Observable } from 'rxjs';

@Controller()
export class ConsultaController {
  logg = new Logger('Archivo y Consulta');
  constructor(private readonly consultaService: ConsultaService) {}
  @MessagePattern({ cmd: CONSULTANIT_CMD_NIT })
  findOne(@Payload('cc') cc: string) {
    const data = this.consultaService.search_nit(cc);
    return data;
  }

  @MessagePattern({ cmd: CONSULTANIT_CMD_NITS })
  async findNits(@Payload('data') data: []): Promise<Observable<string>> {
    try {
      await this.consultaService.generateTxtFile(data);
      this.logg.log('Archivo generado');
      return this.consultaService.streamConsulta();
    } catch (error) {
      this.logg.error(`Error al generar el archivo`, error);
      throw error;
    }
  }
}
