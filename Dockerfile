FROM public.ecr.aws/docker/library/node:22-alpine AS builder

WORKDIR /excalidraw-room

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY tsconfig.json ./
COPY src ./src
RUN yarn build

FROM public.ecr.aws/docker/library/node:22-alpine

RUN apk upgrade --no-cache \
    && apk add --no-cache tini \
    && addgroup -S app \
    && adduser -S app -G app

WORKDIR /excalidraw-room

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile --ignore-scripts \
    && yarn cache clean \
    && rm -rf /usr/local/lib/node_modules/yarn /usr/local/lib/node_modules/npm \
       /usr/local/bin/yarn /usr/local/bin/yarnpkg /usr/local/bin/npm /usr/local/bin/npx

COPY --from=builder /excalidraw-room/dist ./dist

USER app

EXPOSE 3002
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]
