FROM node:20

WORKDIR /usr/src/ConsultaNit_Service

# Copiar los archivos de tu proyecto
COPY . /usr/src/ConsultaNit_Service/

# Instalar pnpm
RUN npm install -g pnpm

# Instalar las dependencias del proyecto
RUN pnpm install

# Compilar el proyecto (esto genera la carpeta dist)
RUN pnpm build

# Exponer el puerto de la aplicación
EXPOSE ${CONSULTANIT_PORT}

# Comando para ejecutar el proyecto compilado
CMD [ "node", "dist/main.js" ]
