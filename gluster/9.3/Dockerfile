#
# Gluster v9.x
#
# We intentionally use ubuntu, over debian or alpine (our default)
# due to the better officially maintained PPA repositories, and the overcomplicated
# requirement to clear out / modify the install porcess for debian/centos
#
# Frankly given the current lack of official suppport in docker / debian
# and out lack of centos expertise - this was considered the best compromise
#
# Ubuntu PPA: https://launchpad.net/~gluster/+archive/ubuntu/glusterfs-9
#
FROM ubuntu:bionic
MAINTAINER Eugene Cheah <eugene@uilicious.com>

# Install Gluster with fixed versioning
RUN apt-get update && \
    apt-get install -y xtail software-properties-common && \
    add-apt-repository ppa:gluster/glusterfs-9 && \
    apt-get update && \
    apt-get install -y glusterfs-server=9.3\* && \
    rm -rf /var/lib/apt/lists/*

# Console logging mode, user either
#
# TAIL  : Tails the log directory '/var/log/glusterfs/' (default)
# NONE  : Disable console logging
# DEBUG : Enable debug mode, and logs to the console
ENV DOCKER_LOGGING_MODE="TAIL"

# Copy over the entrpoint file
# and grant it execute permission
COPY glusterd-entrypoint.sh /glusterd-entrypoint.sh
RUN chmod 0755 /glusterd-entrypoint.sh && \
    chmod +x /glusterd-entrypoint.sh

# Glusterd entrypoint + run in foreground
ENTRYPOINT [ "/glusterd-entrypoint.sh" ]

# CMD can be used to pass additional arguments to glusterd
# Currently only --no-daemon is passed by default
CMD []
