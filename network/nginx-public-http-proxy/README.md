# uilicious/nginx-public-http-proxy

+ https://hub.docker.com/r/uilicious/nginx-public-http-proxy/
+ https://github.com/uilicious/uilicious-dockerfile/tree/master/network/nginx-public-http-proxy

## Summary and configuration

A public HTTP/HTTPS/FTP_PROXY running on the default 3128.

DNS resolver is configured to 8.8.8.8

## !!! INSECURE PROXY WARNING !!!

This is an INSECURE proxy, never, ever run this on a public network,
without some other restrictions, such as a whitelist IP firewall.

3128 is a known default port for proxy, having this exposed to the interent, 
means bot WILL find out about it and abuse it. Giving you a real bad time.

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/uilicious/uilicious-dockerfile
