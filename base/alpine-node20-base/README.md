# uilicious/alpine-node20-base

+ Docker Hub: https://hub.docker.com/r/uilicious/alpine-node20-base/
+ Source: https://github.com/uilicious/uilicious-dockerfile/tree/master/base/alpine-node20-base

Modern Node.js 20 LTS base image on **Alpine Linux 3.20**. Designed for building and running Node.js and TypeScript applications across Uilicious services and multi-stage Docker build pipelines.

## Included Packages & Runtimes

- **Alpine Linux**: 3.20
- **Node.js**: Node.js 20 LTS (`nodejs`)
- **Package Manager**: npm 10 (`npm`)
- **Utilities**: `bash`, `curl`, `wget`, `ca-certificates`, `tzdata`, `iputils`, `grep`, `jq`

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `TZ` | `GMT+0` | Default UTC timezone |
| `LANG` | `en_US.UTF-8` | Default UTF-8 character encoding |
| `LANGUAGE` | `en_US.UTF-8` | Language environment |

## Predefined Directories

- `/application/` : Default working directory (`WORKDIR /application/`).

## Usage Example

### In Multi-Stage Dockerfile (TypeScript Builder)

```dockerfile
FROM uilicious/alpine-node20-base:latest AS builder

WORKDIR /application/

COPY package*.json tsconfig.json ./
RUN npm ci

COPY ./src ./src
RUN npm run build

FROM uilicious/alpine-node20-base:latest
WORKDIR /application/
COPY --from=builder /application/dist ./dist
COPY --from=builder /application/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```
