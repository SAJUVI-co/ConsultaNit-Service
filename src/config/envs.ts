import 'dotenv';
import * as joi from 'joi';

interface Envs {
  PORT: number;
}

const schema = joi
  .object({
    PORT: joi.number().required(),
  })
  .unknown(true);

const data = schema.validate(process.env);

if (data.error) {
  throw new Error(`Config validation error: ${data.error.message}`);
}

export const { PORT } = data.value as Envs;
