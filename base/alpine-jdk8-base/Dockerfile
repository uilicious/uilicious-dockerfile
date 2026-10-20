#
# Alpine 3.20 base image with OpenJDK 8 JDK and development tools
#
# Docker Hub: uilicious/alpine-jdk8-base
#
FROM alpine:3.20

# Standard environment variables
ENV TZ="GMT+0" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Install Java 8 JDK, glibc compatibility for Gradle file-events, git, and core build utilities
RUN apk add --no-cache \
    openjdk8 \
    libc6-compat \
    git \
    bash \
    curl \
    wget \
    ca-certificates \
    tzdata \
    iputils \
    grep \
    jq && \
    rm -rf /var/cache/apk/*

# Java 8 JDK environment
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/bin:/usr/lib/jvm/java-1.8-openjdk/jre/bin

WORKDIR /application/

CMD ["/bin/bash"]
