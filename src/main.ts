import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { Logger } from '@nestjs/common';
import { CONSULTANIT_HOST, CONSULTANIT_PORT } from './config/env.config';

async function bootstrap() {
  const app = await NestFactory.createMicroservice<MicroserviceOptions>(
    AppModule,
    {
      transport: Transport.TCP,
      options: {
        host: CONSULTANIT_HOST, // Cambia esto al host que necesites
        port: CONSULTANIT_PORT, // Cambia el puerto aquí
      },
    },
  );
  await app.listen();

  const logger = new Logger('ConsultaNIT Service');
  logger.log(`Service Running on ${3001} port`);
}
bootstrap().catch((error) => {
  const logger = new Logger('Bootstrap');
  logger.error('Error during bootstrap', error);
});
