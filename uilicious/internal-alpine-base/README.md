# uilicious/internal-alpine-base

> [!WARNING]
> **DEPRECATED**: This legacy image is deprecated. It contains obsolete runtimes (Node 8, Python 2, Apache Ant) based on Alpine 3.8.
> New projects and modernizations should use the Alpine 3.20 base image suite under `base/`:
> - `uilicious/alpine-jre8-base`: Lightweight Java 8 JRE runtime for pure backend services
> - `uilicious/alpine-jdk8-base`: Java 8 JDK for Gradle compilation and CI test runners
> - `uilicious/alpine-node20-base`: Node.js 20 LTS for frontend/engine builders
> - `uilicious/alpine-jre8-node20-base`: Combined Java 8 JRE + Node.js 20 LTS + native compilation tools for hybrid test runners

**warning! : not recommended for public usage**

alpine base container customized for uilicious internal application containers use case.

These are made public, as a point of reference for other projects. And should not be used directly by any other non-uilicious projects.
