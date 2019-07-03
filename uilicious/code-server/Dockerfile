# @TODO - consider a "STABLE" tag once its out
FROM codercom/code-server:latest

# Setup build essentials and docker
RUN sudo apt-get update && \
	sudo apt-get install -y build-essential curl file git docker software-properties-common

# Setup various other things
RUN sudo apt-get update && \
	sudo apt-get install -y bash gettext curl wget vim ca-certificates ffmpeg graphicsmagick python make g++

# Install homebrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# Lets reconfigure shell and homebrew path
# This deviates from the official setup steps (see below)
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash

# The following is the official steps on setting hombrew path does not work for this container
#
# ```
# RUN test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv); \
# 	test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv); \
# 	test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile; \
# 	echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
# ```
#
# We even tried this
# ```
# RUN echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.profile
# ```
#
# Documented here to prevent someone else from trying to change it to official steps (again)

# Installing openjdk8
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
RUN sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/; \
	sudo apt-get update && sudo apt-get install -y adoptopenjdk-8-hotspot

# Lets install gradle / ant
RUN brew install gradle ant

# Lets install nodejs/npm
RUN sudo apt-get install npm nodejs

# And http-server, uilicious-cli (useful)
RUN sudo npm install -g http-server
