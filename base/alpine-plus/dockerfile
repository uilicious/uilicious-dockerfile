#
# Alpine base image, with openjdk8 & node 8, see README for more details
#
# VERSION               1.0.1
#
FROM uilicious/alpine-nodejs

###
#
# openjdk setup - taken from :
# https://github.com/docker-library/openjdk/blob/38cb0eb077acf2a429f32a879903cd305733d561/8/jdk/alpine/Dockerfile
#
# MIT license : https://github.com/docker-library/openjdk/blob/38cb0eb077acf2a429f32a879903cd305733d561/LICENSE
#
###

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u191
ENV JAVA_ALPINE_VERSION 8.191.12-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]
