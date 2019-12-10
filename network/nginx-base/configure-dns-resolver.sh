#!/bin/sh

# Lets setup `/etc/nginx/dns-resolver.conf` (if needed)
if [ "$DNS_SETUP_CONF" = "1" ] 
then
    # Fetch the DNS resolver
    RESOLVER="$DNS"
    if [ -z "$RESOLVER" ]; then
        RESOLVER=$(cat /etc/resolv.conf | grep "nameserver" | awk "{print \$2}")
    fi

    if [ -n "$DNS_VALID_TIMEOUT" ]; then
        RESOLVER="$RESOLVER valid=$DNS_VALID_TIMEOUT"
    fi
    echo "resolver $RESOLVER ;" > /etc/nginx/dns-resolver.conf
else
    echo "" > /etc/nginx/dns-resolver.conf
fi

# Chain the execution commands
exec "$@"
