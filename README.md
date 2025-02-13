# ConsultaNit Service

### Este servicio ha sido deprecado

Este es un servicio basado en VBS, cuyo objetivo es realizar consultas a [https://muisca.dian.gov.co/WebRutMuisca/DefConsultaEstadoRUT.faces](https://muisca.dian.gov.co/WebRutMuisca/DefConsultaEstadoRUT.faces), validar y retornar la información.

## Licencia

Este servicio es de uso exclusivo de **SAJUVI.sas**.

## Autor



## Pasos de Instalación

1. Abrir propiedades de internet.
2. Ir al apartado de Opciones Avanzadas.
3. Ubicarse en el módulo de examinar.
4. Verificar que la opción "Habilitar extensiones de explorador de terceros" esté activada.
5. Clonar el repo:
   ```bash
   git clone https://github.com/SAJUVI-co/ConsultaNit-Service.git
   ```
6. Modo de uso: Para usarlo, solo se debe inicializar el archivo y enviarle el parámetro de la consulta a realizar, por ejemplo::
    ```bash
    cscript .\dataX.vbs [C.C.]
    ```

## Problemas comunes
Si sale algún error de PowerShell, ejecutar el siguiente comando en la consola:

```bash
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
Luego, volver a intentar ejecutar el script.

## Requisitos del sistema
Este script, solo funciona por el momento en entornos como:
- Windows 11 24H2 v.26100.2894

## Autores 
- Mauricio 
- Juan Avila

# Licencia

Este servicio es de uso exclusivo de **SAJUVI.sas**. Queda prohibida la distribución y uso fuera de este contexto.


