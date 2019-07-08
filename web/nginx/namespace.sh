#!/bin/sh

# Lets load up the name server as needed
if [ -z "$NAMESERVER" ]
then
	# Get the NAMESERVER config
	export NAMESERVER=`cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | tr '\n' ' '`
fi

# Lets setup `/etc/nginx/conf.d/00-resolve.conf` (if needed)
if [ "$SETUP_RESOLVE_CONF" = "1" ] 
then
	echo "resolver $NAMESERVER ;"
fi

# Chain the execution commands
exec "$@"
