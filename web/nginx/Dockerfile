##########################################################################
#
#  Nginx image with NAMESERVER environment variable detection script
#
#  Automatically setup /etc/nginx/conf.d/00-namespace.conf
#
##########################################################################
FROM nginx:alpine

##########################################################################
#
# Environment variables, options
#
##########################################################################

#
# DNS NAMESERVER ip addresses to use,
# leave it as blank to autodetect from `/etc/resolve.conf`
#
ENV NAMESERVER=""

#
# Enable setup of `/etc/nginx/conf.d/00-resolve.conf` with
# `resolver $NAMESERVER ;`
#
# This is automatically imported via `/etc/nginx/nginx.conf`
# via the line `include /etc/nginx/conf.d/*.conf;`
#
ENV SETUP_RESOLVE_CONF="1"

##########################################################################
#
# Container setup
#
##########################################################################

# Entrypoint folder setup
RUN mkdir -p /entrypoint/ 

# Namespace script setup
COPY namespace.sh /entrypoint/namespace.sh
RUN chmod 555 /entrypoint/namespace.sh; chmod +x /entrypoint/namespace.sh;

# Setup entrypoint script, which does the `00-namespace.conf` setup
ENTRYPOINT ["/entrypoint/namespace.sh"]

# Start nginx deamon by default
CMD nginx -g "daemon off;"
