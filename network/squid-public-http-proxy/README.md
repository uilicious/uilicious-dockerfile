# uilicious/squid-public-http-proxy

+ https://hub.docker.com/r/uilicious/squid-public-http-proxy/
+ https://github.com/uilicious/uilicious-dockerfile/tree/master/network/squid-public-http-proxy

## Summary and configuration

A public HTTP/HTTPS/FTP_PROXY running on the default 3128.

## !!! INSECURE PROXY WARNING !!!

This is an INSECURE proxy, never, ever run this on a public network,
without some other restrictions, such as a whitelist IP firewall.

3128 is a known default port for proxy, having this exposed to the interent, 
means bot WILL find out about it and abuse it. Giving you a real bad time.

## !!! DO NOT DEPLOY BLINDLY IN PRODUCTION !!!

When deployed insecurely, you will be asking for hackers, spammers, botnets, and many worse evil on your network.

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/uilicious/uilicious-dockerfile
