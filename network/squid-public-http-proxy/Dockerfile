#
# Alpine, configured with a public squid proxy
#
FROM alpine:latest

# Install squid
RUN apk add squid;

# Configure squid
COPY squid.conf /etc/squid/squid.conf

# Proxy port
EXPOSE 3128

# Setup squid as entrypoint
# and --foreground as default cmd option
ENTRYPOINT [ "squid" ]
CMD [ "--foreground" ]