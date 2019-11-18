# Provides a nginx proxy, from one http to another =)
#
# VERSION               2.0.1
#
FROM            nginx:alpine

# Makes only the entry point, no other points needed
RUN mkdir /entrypoint;

# Port to expose, this is currently fixed to 80
EXPOSE 80

##########################
#
# Common nginx settings
#
##########################

# Server host to make request to,
# you may use a named container of "webhost" instead
ENV FORWARD_HOST webhost

# The destination server port
ENV FORWARD_PORT 80

# The forwarding protocall
ENV FORWARD_PROT "http"

# Nginx proxy read timed, default is 600 seconds (10 minutes)
ENV PROXY_READ_TIMEOUT 600s

# Nginx proxy initial connection timeout, default is 5 seconds
ENV PROXY_CONNECT_TIMEOUT 5s

# Client max body size conig (default disabled)
ENV MAX_BODY_SIZE 100M

# Client buffer size, before writing a tmp file
ENV MAX_BUFFER_SIZE 10M

# DNS server to use (if configured)
ENV DNS ""

# DNS Validity timeframe
#
# This can be set as blank to follow DNS declared settings
# intentionally set to 10s to avoid DNS storms
ENV DNS_VALID_TIMEOUT 10s

##########################
#
# Advance nginx settings
#
##########################

# The forward upstream to use within the 
# "upstream backend { ... }" block.
#
# Note that using this setting WILL cause the
# FORWARD_HOST / FORWARD_PORT settings to be ignored
#
# An example fail over format would be the following
#
# ```
# server primaryServer:80 fail_timeout=1s;
# server backupServer:80 backup;
# ```
#
ENV FORWARD_UPSTREAM ""

# Zone upstream size
#
# This is required, for the resolver to work,
# Default is 1m which is enough for almost all cases.
ENV UPSTREAM_ZONE_SIZE 1m

# Automatic failover on multiple upstream, if configured
# Note that this is only useful in conjuncture with FORWARD_UPSTREAM
ENV PROXY_NEXT_UPSTREAM "error timeout invalid_header http_500 http_502 http_503 http_504 http_403 http_404 http_429"

# Additional Custom nginx http level setting to add (if applicable)
ENV NGINX_HTTP_CONFIG ""

# Additional Custom nginx server level setting to add (if applicable)
ENV NGINX_SERVER_CONFIG ""

# Additional Custom nginx root location level setting to add (if applicable)
ENV NGINX_ROOT_LOCATION_CONFIG ""

##########################
#
# @TODO : Cache settings support?
#
##########################

#
# Prepares the entrypoint primer script
#
COPY primer.sh /entrypoint/
RUN cat /entrypoint/primer.sh && chmod +x /entrypoint/primer.sh

#
# Run it once
#
RUN /entrypoint/primer.sh;

#
# Useful for debugging
#
# RUN cat /etc/nginx/conf.d/default.conf;
# RUN cat /entrypoint/primer.sh;
#

ENTRYPOINT ["/entrypoint/primer.sh"]
CMD nginx -g "daemon off;"
