FROM node:18.20.2-alpine

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
