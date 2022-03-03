#####################################################################################################################
#####################################################################################################################
#
# Lets setup the uilicious custom "ubuntu-base" image with ...
#
# + node.js
# + several bash tools
#
# or in other words : uilicious application OS dependencies
#
#####################################################################################################################
#####################################################################################################################

FROM node:16-bullseye

###
#
# Setup for application dependencies
#
###

# Install script tools
RUN apt-get update && \
    apt-get install -y bash gettext curl wget vim iputils jq python make g++ apache-ant && \
    rm -rf /var/lib/apt/lists/*
