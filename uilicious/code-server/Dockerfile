# @TODO - consider a "STABLE" tag once its out
FROM codercom/code-server:4.9.1-bullseye

# Setup build essentials and docker
RUN sudo apt-get update && \
	sudo apt-get install -y build-essential curl file git docker.io software-properties-common

# Setup various other things
RUN sudo apt-get update && \
	sudo apt-get install -y bash gettext curl wget vim ca-certificates ffmpeg graphicsmagick python make g++

# Install homebrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# Lets reconfigure shell and homebrew path
# This deviates from the official setup steps (see below)
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH \
	SHELL=/bin/bash

# The following is the official steps on setting hombrew path which does NOT work for this container
#
# ```
# RUN test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv); \
# 	test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv); \
# 	test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile; \
# 	echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
# ```
#
# I even tried this
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
RUN sudo apt-get update && sudo apt-get install -y ant gradle

# Do not use the brew install version, as it conflicts with JDK8 installed above
# RUN brew install gradle ant

# Lets install nodejs/npm
RUN sudo apt-get update && sudo apt-get install -y npm nodejs

# And http-server (useful for a quick preview / debug)
RUN sudo npm install -g http-server

# Side note: consider mounting `/home/coder/.local/` or `/home/coder/.local/extensions/`
# as a volume to cache local vscode extensions / etc
