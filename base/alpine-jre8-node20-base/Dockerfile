#
# Alpine 3.20 base image with OpenJDK 8 JRE, Node.js 20 LTS, and native build tools
#
# Docker Hub: uilicious/alpine-jre8-node20-base
#
FROM uilicious/alpine-jre8-base:latest


# Install Node.js 20 LTS, npm, and native compilation toolchain for node-gyp / fibers
RUN apk add --no-cache \
    nodejs \
    npm \
    python3 \
    make \
    g++ \
    vim \
    gettext && \
    rm -rf /var/cache/apk/*

WORKDIR /application/

CMD ["/bin/bash"]
