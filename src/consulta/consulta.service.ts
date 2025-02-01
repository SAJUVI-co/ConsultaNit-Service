import { Injectable } from '@nestjs/common';
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

  async findOne(cc: string): Promise<string> {
    const data = await this.search_nit(cc);
    console.log(data);
    return data; // QUEDA PENDIENTE VALIDAR EL ERROR DE ESLINT
  }
}
