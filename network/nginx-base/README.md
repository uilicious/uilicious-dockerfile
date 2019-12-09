# uilicious/nginx-base

https://hub.docker.com/r/uilicious/nginx-base/
https://github.com/uilicious/dockerfiles/tree/master/network/nginx-base

## Summary and configuration
Simple nginx server, with autodetected DNS resolver - supports local internal ip of docker clusters

Environment configuration is as followed in the Dockerfile.

``` 
# DNS server to use (if configured)
ENV DNS ""

# DNS Validity timeframe
#
# This can be set as blank to follow DNS declared settings
# intentionally set to 10s to avoid DNS storms
ENV DNS_VALID_TIMEOUT 10s
```

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/picoded/dockerfiles
