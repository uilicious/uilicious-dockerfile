#!/bin/sh
# Fetch the DNS resolver
RESOLVER="$DNS"
if [ -z "$RESOLVER" ]; then
    RESOLVER=$(cat /etc/resolv.conf | grep "nameserver" | awk "{print \$2}")
fi

if [ -n "$DNS_VALID_TIMEOUT" ]; then
    RESOLVER="$RESOLVER valid=$DNS_VALID_TIMEOUT"
fi
echo "resolver $RESOLVER ;" > /etc/nginx/resolvers.conf

# Goes into the nginx config folder
cd /etc/nginx/conf.d/

# Setup the server config
echo "# http level config"                                                         > default.conf
echo "client_max_body_size ${MAX_BODY_SIZE};"                                      >> default.conf
echo ""                                                                            >> default.conf
echo "# Dynamic IP DNS workaround"                                                 >> default.conf
echo "include resolvers.conf;"                                                     >> default.conf
echo ""                                                                            >> default.conf
echo "upstream forward_backend {"                                                  >> default.conf
echo "   zone forward_backend_zone ${UPSTREAM_ZONE_SIZE};"                         >> default.conf
echo ""                                                                            >> default.conf
if [ -n "$FORWARD_UPSTREAM" ]; then
   if [[ "${FORWARD_UPSTREAM: -1}" == ";" ]]; then
      echo "   ${FORWARD_UPSTREAM}"                                                >> default.conf
   else
      echo "   ${FORWARD_UPSTREAM};"                                               >> default.conf
   fi
else
   echo "   server ${FORWARD_HOST}:${FORWARD_PORT};"                               >> default.conf
fi
echo "}"                                                                           >> default.conf
echo ""                                                                            >> default.conf
echo "# Custom NGINX http level config (if applicable)"                            >> default.conf
echo "${NGINX_HTTP_CONFIG}"                                                        >> default.conf
echo ""                                                                            >> default.conf
echo "server {"                                                                    >> default.conf
echo "   listen 80 default_server;"                                                >> default.conf
echo "   client_max_body_size ${MAX_BODY_SIZE};"                                   >> default.conf
echo ""                                                                            >> default.conf
echo "   # Proxy next upstream handling (if applicable)"                           >> default.conf
echo "   ${NGINX_SERVER_CONFIG}"                                                   >> default.conf
echo ""                                                                            >> default.conf
echo "   # Additional Nginx server level config (if applicable)"                   >> default.conf
echo "   proxy_next_upstream ${PROXY_NEXT_UPSTREAM};"                              >> default.conf
echo ""                                                                            >> default.conf
echo "   location / {"                                                             >> default.conf
echo "      proxy_pass                    ${FORWARD_PROT}://forward_backend;"      >> default.conf
echo "      proxy_http_version            1.1;"                                    >> default.conf
# echo "      proxy_set_header Connection   ''"                                      >> default.conf
echo ""                                                                            >> default.conf
echo "      proxy_connect_timeout         ${PROXY_CONNECT_TIMEOUT};"               >> default.conf
echo "      proxy_read_timeout            ${PROXY_READ_TIMEOUT};"                  >> default.conf
echo ""                                                                            >> default.conf
echo "      proxy_pass_request_headers    on;"                                     >> default.conf
echo "      proxy_set_header     X-Forwarded-For \$proxy_add_x_forwarded_for;"     >> default.conf
echo ""                                                                            >> default.conf
echo "      client_max_body_size ${MAX_BODY_SIZE};"                                >> default.conf
echo "      client_body_buffer_size ${MAX_BUFFER_SIZE};"                           >> default.conf
echo ""                                                                            >> default.conf
echo "      # Additional Nginx root location level config (if applicable)"         >> default.conf
echo "      ${NGINX_ROOT_LOCATION_CONFIG}"                                         >> default.conf
echo "   }"                                                                        >> default.conf
echo "}"                                                                           >> default.conf

# Goes back to root folder
cd /

# Chain the execution commands
exec "$@"
