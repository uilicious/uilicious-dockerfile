#!/bin/sh
# Fetch the DNS resolver
RESOLVER="$DNS"
if [ -z "$RESOLVER" ]; then
    RESOLVER=$(cat /etc/resolv.conf | grep "nameserver" | awk "{print \$2}")
fi

if [ -n "$DNS_VALID_TIMEOUT" ]; then
    RESOLVER="$RESOLVER valid=$DNS_VALID_TIMEOUT"
fi
echo "resolver $RESOLVER ;" > /etc/nginx/dns-resolver.conf

# Chain the execution commands
exec "$@"
