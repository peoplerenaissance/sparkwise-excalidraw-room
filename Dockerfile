#syntax=docker/dockerfile:1

# ============== BUILDER ==============
# Full Node image: install all dependencies (incl. devDeps) and compile
# TypeScript -> dist. Debian base (glibc) is paired deliberately with the
# glibc distroless runtime below.
FROM public.ecr.aws/docker/library/node:22-trixie-slim AS builder

WORKDIR /excalidraw-room

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile && yarn cache clean

COPY tsconfig.json ./
COPY src ./src
RUN yarn build

# ============== PROD-DEPS ==============
# Production-only node_modules, copied verbatim into the distroless runtime
# (which ships no yarn/npm to install them). --ignore-scripts: no package
# lifecycle scripts run while building the image.
FROM public.ecr.aws/docker/library/node:22-trixie-slim AS prod-deps

WORKDIR /excalidraw-room

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile --ignore-scripts && yarn cache clean

# ============== RUNTIME ==============
# Distroless nodejs22 (Debian 13) :nonroot — no shell, no package managers,
# runs as UID 65532. The image's `node` is the default ENTRYPOINT, so CMD is
# just the script path. Node runs as PID 1 and handles SIGTERM/SIGINT itself;
# the graceful-shutdown handler lives in src/index.ts.
FROM gcr.io/distroless/nodejs22-debian13:nonroot

ENV NODE_ENV=production

WORKDIR /excalidraw-room

COPY --from=prod-deps /excalidraw-room/node_modules node_modules
COPY --from=builder /excalidraw-room/dist dist
COPY package.json ./

EXPOSE 3002

CMD ["dist/index.js"]
