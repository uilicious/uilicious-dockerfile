#####################################################################################################################
#####################################################################################################################
#
# Lets setup the uilicious custom "alpine-base" image with ...
#
# + node.js
# + java 8
# + ffmpeg
# + graphicmagick
# + python
# + make
# + g++
# + apache-ant
# + several bash tools
#
# or in other words : uilicious application OS dependencies
#
#####################################################################################################################
#####################################################################################################################

FROM uilicious/alpine-plus:latest

###
#
# Setup for application dependencies
#
###

# Install script tools
RUN apk add --no-cache bash gettext curl wget vim iputils

# Install ffmpeg
RUN apk upgrade -U \
 && apk add ca-certificates ffmpeg libva-intel-driver \
 && rm -rf /var/cache/*

# Install graphicsmagick
RUN apk add --no-cache graphicsmagick

# Install alpine build dependencies for fibers, and ant for java compilation
RUN apk add --no-cache python make g++ apache-ant
