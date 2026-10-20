#
# Alpine 3.20 base image with OpenJDK 8 Headless JRE
#
# Docker Hub: uilicious/alpine-jre8-base
#
FROM alpine:3.20

# Standard environment variables
ENV TZ="GMT+0" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Install Java 8 JRE, glibc compatibility layer, and core runtime utilities
RUN apk add --no-cache \
    openjdk8-jre \
    libc6-compat \
    bash \
    curl \
    wget \
    ca-certificates \
    tzdata \
    iputils \
    grep \
    jq && \
    rm -rf /var/cache/apk/*

# Java 8 JRE environment
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin

WORKDIR /application/

CMD ["/bin/bash"]
