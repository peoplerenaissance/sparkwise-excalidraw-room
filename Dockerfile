FROM public.ecr.aws/docker/library/node:22.15-alpine

RUN apk update && apk upgrade
RUN npm install -g npm@latest

WORKDIR /excalidraw-room

COPY package.json yarn.lock ./
RUN yarn

COPY tsconfig.json ./
COPY src ./src
RUN yarn build

EXPOSE 80
CMD ["yarn", "start"]
