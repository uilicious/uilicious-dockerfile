#!/bin/bash

# Get the current gluster version
echo "### glusterd version"
glusterd --version

# Log the docker logging mode
echo "### DOCKER_LOGGING_MODE: $DOCKER_LOGGING_MODE"

# Handles the log tailing of files
if [ "$DOCKER_LOGGING_MODE" == "TAIL" ]; then
    echo "### Enabling log tailing for docker"
    xtail -f /var/log/glusterfs &
fi

# Handle debug mode, and all other modes
if [[ "$DOCKER_LOGGING_MODE" == "DEBUG" ]] || [[ "$@" == *"--debug"* ]]; then
    echo "### Running glusterd in debug mode"
    glusterd --no-daemon --debug $@
else
    echo "### Running glusterd"
    glusterd --no-daemon $@
fi
