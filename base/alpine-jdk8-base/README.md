# uilicious/alpine-jdk8-base

+ Docker Hub: https://hub.docker.com/r/uilicious/alpine-jdk8-base/
+ Source: https://github.com/uilicious/uilicious-dockerfile/tree/master/base/alpine-jdk8-base

Comprehensive Java 8 development and build base image on **Alpine Linux 3.20**. Designed specifically for compilation stages (Gradle / Maven), CI/CD pipelines (GitLab CI test runners), and developer containers.

## Included Packages & Runtimes

- **Alpine Linux**: 3.20
- **Java Development Kit**: OpenJDK 8 Full JDK (`openjdk8` with `javac`, `jar`, `javap`)
- **Source Control**: `git` (for submodule management and version tracking)
- **Compatibility**: `libc6-compat` (provides `ld-linux-x86-64.so.2` compatibility required by Gradle native services and file system watchers)
- **Utilities**: `bash`, `curl`, `wget`, `ca-certificates`, `tzdata`, `iputils`, `grep`, `jq`

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `JAVA_HOME` | `/usr/lib/jvm/java-1.8-openjdk` | Points to Java 8 JDK root |
| `PATH` | `$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin` | Ensures `javac` and `java` are in PATH |
| `TZ` | `GMT+0` | Default UTC timezone |
| `LANG` | `en_US.UTF-8` | Default UTF-8 character encoding |
| `LANGUAGE` | `en_US.UTF-8` | Language environment |

## Predefined Directories

- `/application/` : Default working directory (`WORKDIR /application/`).

## Usage Example

### In Multi-Stage Dockerfile (Builder)

```dockerfile
FROM uilicious/alpine-jdk8-base:latest AS builder

WORKDIR /application/

COPY ./ ./

# Compile using Gradle wrapper with zero runtime package installations
RUN ./gradlew build

FROM uilicious/alpine-jre8-base:latest
WORKDIR /application/
COPY --from=builder /application/build/libs/app.jar ./
CMD ["java", "-jar", "app.jar"]
```

### In GitLab CI (`.gitlab-ci.yml`)

```yaml
gradle-build:
  image: uilicious/alpine-jdk8-base:latest
  stage: build
  script:
    - ./gradlew classes
```
