# uilicious/alpine-jre8-node20-base

+ Docker Hub: https://hub.docker.com/r/uilicious/alpine-jre8-node20-base/
+ Source: https://github.com/uilicious/uilicious-dockerfile/tree/master/base/alpine-jre8-node20-base

Hybrid Java 8 JRE and Node.js 20 LTS runtime base image on **Alpine Linux 3.20**. Extends from [`uilicious/alpine-jre8-base`](../alpine-jre8-base) and includes Node.js 20 LTS alongside a pre-installed native C/C++ compilation toolchain (`python3`, `make`, `g++`).

Designed specifically for hybrid execution engines (such as the UI-licious test runner) that run a Java runtime while executing or dynamically building native Node modules (such as `fibers`, Playwright bindings, and node-gyp packages) with zero runtime package installations.

## Included Packages & Runtimes

- **Inherited from `uilicious/alpine-jre8-base`**:
  - Alpine Linux 3.20
  - OpenJDK 8 Headless JRE (`openjdk8-jre`)
  - `libc6-compat` (glibc compatibility layer)
  - `bash`, `curl`, `wget`, `ca-certificates`, `iputils`, `grep`, `jq`
- **Node.js**: Node.js 20 LTS (`nodejs`) + npm 10 (`npm`)
- **Native Compilation Toolchain**: `python3`, `make`, `g++` (for `node-gyp` native addon builds)
- **Editor & Utilities**: `vim`, `gettext`

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `JAVA_HOME` | `/usr/lib/jvm/java-1.8-openjdk/jre` | Inherited from `alpine-jre8-base` |
| `PATH` | `$PATH:$JAVA_HOME/bin` | Inherited from `alpine-jre8-base` |
| `TZ` | `GMT+0` | Inherited from `alpine-jre8-base` (UTC) |
| `LANG` | `en_US.UTF-8` | Default UTF-8 character encoding |
| `LANGUAGE` | `en_US.UTF-8` | Language environment |

## Predefined Directories

- `/application/` : Default working directory (`WORKDIR /application/`).

> [!NOTE]
> Project-specific directories (such as `/storage` with custom permission models) should be configured directly in downstream application Dockerfiles.

## Usage Example

```dockerfile
FROM uilicious/alpine-jre8-node20-base:latest

WORKDIR /application/

# Copy built artifacts from earlier builder stages
COPY --from=jar_builder /application/build/libs/test-runner-all.jar ./
COPY --from=engine_builder /application/dist ./engine/dist

# Downstream application directory configuration
RUN mkdir -p /storage && chmod -R 777 /storage

EXPOSE 8080

CMD ["java", "-jar", "test-runner-all.jar"]
```
