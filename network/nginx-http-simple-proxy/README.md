# uilicious/nginx-http-simple-proxy

https://hub.docker.com/r/uilicious/nginx-http-simple-proxy/
https://github.com/uilicious/dockerfiles/tree/master/network/nginx-http-simple-proxy

## Summary and configuration
A simple nginx server, which proxy-s another endpoint.

Environment configuration is as followed in the Dockerfile.

``` 
#
# Server host to make request to, 
# you may use a named container of "webhost" instead
#
ENV FORWARD_HOST webhost

# The destination server port
ENV FORWARD_PORT 80

# The forwarding protocall
ENV FORWARD_PROT "http"

# Nginx proxy read timed, default is 600 seconds (10 minutes)
ENV PROXY_READ_TIMEOUT 600
```

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/picoded/dockerfiles
