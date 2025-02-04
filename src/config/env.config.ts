import 'dotenv/config'; // Asegúrate de cargar el archivo .env al inicio
import * as joi from 'joi';

interface Envs {
  CONSULTANIT_HOST: string;
  CONSULTANIT_CMD_NIT: string;
  CONSULTANIT_CMD_NITS: string;
  CONSULTANIT_PORT: number;
}

const schema = joi
  .object({
    CONSULTANIT_HOST: joi.string().required(),
    CONSULTANIT_PORT: joi.number().required(),
    CONSULTANIT_CMD_NIT: joi.string().required(),
    CONSULTANIT_CMD_NITS: joi.string().required(),
  })
  .unknown(true);

const data = schema.validate(process.env);

if (data.error) {
  throw new Error(`Config validation error: ${data.error.message}`);
}

export const {
  CONSULTANIT_HOST,
  CONSULTANIT_PORT,
  CONSULTANIT_CMD_NIT,
  CONSULTANIT_CMD_NITS,
} = data.value as Envs;
