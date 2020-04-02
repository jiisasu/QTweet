FROM node:13.6.0-slim
WORKDIR /usr/src/app

# Install envsubst
RUN apt-get update && apt-get install gettext-base

# Copy build files and install using yarn
COPY package.json ./
COPY yarn.lock ./
RUN yarn install --production

# Copy everything over
COPY . .

ARG BOT_NAME
ARG PREFIX

# Build the language files
RUN for file in ./lang/*.ftl; do f=${file%.ftl}; cat $file | envsubst '$BOT_NAME:$PREFIX' > $f.o.ftl; echo "Built $f.o.ftl "; done

RUN yarn build

CMD [ "node", "-r", "esm", "dist/index.js"]
