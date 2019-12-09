# Provides a nginx proxy, from one http to another =)
#
# VERSION               2.0.1
#
FROM            nginx:alpine

# Makes only the entry point, no other points needed
RUN mkdir /entrypoint;

# Port to expose, this is currently fixed to 80
# EXPOSE 80

##########################
#
# Configurable environment variables
#
##########################

# DNS server to use (if configured)
ENV DNS ""

# DNS Validity timeframe
#
# This can be set as blank to follow DNS declared settings
# intentionally set to 10s to avoid DNS storms
ENV DNS_VALID_TIMEOUT 10s

##########################
#
# Entrypoint primer
#
##########################

#
# Prepares the entrypoint script that dynamically loads configured resolver
#
COPY configure-dns-resolver.sh /entrypoint/
RUN cat /entrypoint/configure-dns-resolver.sh && chmod +x /entrypoint/configure-dns-resolver.sh

#
# Init the default resolver
#
RUN echo "resolver 127.0.0.1 ;" > /etc/nginx/dns-resolver.conf

#
# Change the nginx.conf file to include the dns-resolver
#
COPY nginx.conf /etc/nginx/nginx.conf

#
# Useful for debugging
#
# RUN cat /etc/nginx/conf.d/default.conf;
# RUN cat /entrypoint/primer.sh;
#

ENTRYPOINT ["/entrypoint/configure-dns-resolver.sh"]
CMD nginx -g "daemon off;"

