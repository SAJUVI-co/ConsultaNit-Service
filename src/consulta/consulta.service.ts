import { Injectable } from '@nestjs/common';
import { exec, spawn } from 'child_process';
import * as path from 'path';
import * as fs from 'fs';
import { Observable } from 'rxjs';

@Injectable()
/**
 * Método para consultar un solo NIT.
 * Ejecuta el script VBS 'consulta_nit.vbs' pasando como parámetro el NIT (cc).
 * Retorna una Promise que se resuelve con la salida del script o se rechaza si ocurre un error.
 */
export class ConsultaService {
  private search_nit(cc: string): Promise<string> {
    return new Promise((resolve, reject) => {
      exec(
        `cscript //nologo ./src/consulta/consulta_nit.vbs ${cc}`,
        (error, stdout, stderr) => {
          if (error) {
            reject(new Error(`Error ejecutando el script: ${error.message}`));
          } else if (stderr) {
            reject(new Error(`Error del script: ${stderr}`));
          } else {
            resolve(stdout.trim()); // Solo devuelve el JSON limpio
          }
        },
      );
    });
  }

  async findOne(cc: string): Promise<string> {
    const data = await this.search_nit(cc);
    console.log(data);
    return data; // QUEDA PENDIENTE VALIDAR EL ERROR DE ESLINT
  }

  /**
   * Método para iniciar el proceso de consulta masiva de NITs de forma progresiva.
   * Ejecuta el script VBS 'consulta_nits.vbs' usando spawn para poder leer los datos en tiempo real.
   * Retorna un Observable que emite cada fragmento de salida (cada resultado) a medida que se genera.
   */
  public streamConsulta(): Observable<string> {
    return new Observable((observer) => {
      // Construcción de la ruta del script consulta_nits.vbs
      const scriptPath = path.join(__dirname, '..', 'consulta_nits.vbs');
      // Se ejecuta el script usando spawn, lo que permite trabajar con streams (stdout y stderr)
      const child = spawn('cscript', [scriptPath]);

      // Se escucha el evento 'data' en stdout para recibir cada fragmento de datos
      child.stdout.on('data', (data: Buffer) => {
        // Convierte el buffer a string y se envía al Observable
        observer.next(data.toString());
      });

      // Se escucha el evento 'data' en stderr para capturar errores que el script pueda emitir
      child.stderr.on('data', (data: Buffer) => {
        // Emite el error a través del Observable
        observer.error(new Error(data.toString()));
      });

      // Cuando el proceso termina (evento 'close'), se completa el Observable
      child.on('close', () => {
        observer.complete();
      });

      // Función de limpieza: en caso de que se desuscriba, se termina el proceso hijo
      return () => {
        child.kill();
      };
    });
  }

  /**
   * Método para generar el archivo nits.txt a partir de un arreglo de NITs.
   * Une los NITs en líneas separadas y los escribe en un archivo ubicado en la ruta especificada.
   * Retorna una Promise que se resuelve si la escritura es exitosa o se rechaza en caso de error.
   */
  public async generateTxtFile(nits: string[]): Promise<void> {
    return new Promise((resolve, reject) => {
      // Se construye la ruta donde se generará el archivo nits.txt

      const filePath = path.join(__dirname, '..', 'nits.txt');

      // Se une el arreglo de NITs en una cadena, separando cada uno por un salto de línea
      const fileContent = nits.join('\n');

      // Se escribe el contenido en el archivo utilizando fs.writeFile
      fs.writeFile(filePath, fileContent, 'utf8', (err) => {
        if (err) {
          // Si ocurre un error durante la escritura, se registra y se rechaza la Promise
          console.error('Error al escribir el archivo:', err);
          reject(err);
        } else {
          // Se registra en consola el éxito y se resuelve la Promise
          console.log('Archivo nits.txt creado con éxito.');
          resolve();
        }
      });
    });
  }
}
