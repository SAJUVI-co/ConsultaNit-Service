import { Injectable } from '@nestjs/common';
// import { CreateConsultaDto } from './dto/create-consulta.dto';
import { exec } from 'child_process';

@Injectable()
export class ConsultaService {
  private search_nit(cc: string): Promise<string> {
    return new Promise((resolve, reject) => {
      exec(`cscript ../query.vbs ${cc}`, (error, stdout, stderr) => {
        if (error) {
          reject(new Error(`Error ejecutando el script: ${error.message}`));
        } else if (stderr) {
          reject(new Error(`Error del script: ${stderr}`));
        } else {
          resolve(stdout.trim());
        }
      });
    });
  }

  findAll(data: string[]) {
    data.forEach((nit) => {
      console.log(nit);
    });

    return 'nit has been searched';
  }

  findOne(cc: string) {
    return this.search_nit(cc); // QUEDA PENDIENTE VALIDAR EL ERROR DE ESLINT
  }
}
