#
# Alpine 3.20 base image with Node.js 20 LTS and npm 10
#
# Docker Hub: uilicious/alpine-node20-base
#
FROM alpine:3.20

# Standard environment variables
ENV TZ="GMT+0" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Install Node.js 20 LTS, npm 10, and core runtime utilities
RUN apk add --no-cache \
    nodejs \
    npm \
    bash \
    curl \
    wget \
    ca-certificates \
    tzdata \
    iputils \
    grep \
    jq && \
    rm -rf /var/cache/apk/*

WORKDIR /application/

CMD ["/bin/bash"]
