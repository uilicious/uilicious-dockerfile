# uilicious/alpine-jre8-base

+ Docker Hub: https://hub.docker.com/r/uilicious/alpine-jre8-base/
+ Source: https://github.com/uilicious/uilicious-dockerfile/tree/master/base/alpine-jre8-base

Minimal, lightweight Java 8 runtime base image on **Alpine Linux 3.20**. Designed specifically for running compiled Java 8 backend applications (such as the UI-licious API server) with minimal image overhead, fast startup, and reduced attack surface.

## Included Packages & Runtimes

- **Alpine Linux**: 3.20
- **Java Runtime**: OpenJDK 8 JRE (`openjdk8-jre`)
- **Compatibility**: `libc6-compat` (glibc dynamic linker support for native JNI libraries)
- **Utilities**: `bash`, `curl`, `wget`, `ca-certificates`, `tzdata`, `iputils`, `grep`, `jq`

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `JAVA_HOME` | `/usr/lib/jvm/java-1.8-openjdk/jre` | Points to Java 8 JRE installation |
| `PATH` | `$PATH:$JAVA_HOME/bin` | Ensures `java` is in default PATH |
| `TZ` | `GMT+0` | Default UTC timezone |
| `LANG` | `en_US.UTF-8` | Default UTF-8 character encoding |
| `LANGUAGE` | `en_US.UTF-8` | Language environment |

## Predefined Directories

- `/application/` : Default working directory (`WORKDIR /application/`) for application artifacts.

## Usage Example

```dockerfile
FROM uilicious/alpine-jre8-base:latest

WORKDIR /application/

# Copy application artifacts
COPY ./target/my-service.jar ./my-service.jar

EXPOSE 8080

CMD ["java", "-jar", "my-service.jar"]
```
