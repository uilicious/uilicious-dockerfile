# uilicious/gluster-server

https://hub.docker.com/r/uilicious/gluster-server/
https://github.com/uilicious/uilicious-dockerfile/tree/master/gluster

## Summary and configuration

This is primarily meant as a replacement for the offical gluster image found here

https://hub.docker.com/r/gluster/gluster-centos

Which unfortunately is no longer maintained actively (at this point of writing it seems),
so instead we had to build our own replacement container instead.

Also to make this as "Simple as possible" we decided to build it on ubuntu instead,
and pretty much ignore all the docker scripts of the official docker repo - as we do not
use them in our use case. The only tweak we made is the addition of log tailing by default
to ease debugging of issues on kubernetes terminals (like rancher)

**ENV variable supported**

`DOCKER_LOGGING_MODE` : use either of the following settings
- `TAIL` (custom default) which will print the various gluster log files in `/var/log/glusterfs/`
- `DEBUG` to run in debug mode verbosely into the console log (and not write anyfiles), 
- `NONE` no change in docker logging behaviour, which means by default gluster settings it only writes to log files, and print nothing in the console. This is the default for the official container.

## Do not forget to upgrade gluster clients (after servers)

Note you probably should switch off any workload, and do a restart after installs

```
# Dependencies
sudo apt-get install software-properties-common

# For version 7
sudo add-apt-repository ppa:gluster/glusterfs-7

# For version 9
sudo add-apt-repository ppa:gluster/glusterfs-9

# Update and install the client
sudo apt-get update
sudo apt-get install -y glusterfs-client
```

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/picoded/dockerfiles
