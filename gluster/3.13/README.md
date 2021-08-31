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

## Please read the upgrade guide (to avoid downtimes, if possible)

https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-9/

## Gluster Features Deprecation

According to the gluster docs, from version <4, to 4.1 onwards, the following is dropped (see: https://docs.gluster.org/en/latest/Upgrade-Guide/upgrade-to-9/)

- features.lock-heal
- features.grace-timeout

To disable these 2 features you can quickly run the following commands

```
# Iterate all volumes, and ensure the lock-heal and grace-timeout feature is disabled
for i in `gluster volume list`; do echo "## $i"; gluster volume reset $i "features.lock-heal"; done
for i in `gluster volume list`; do echo "## $i"; gluster volume reset $i "features.grace-timeout"; done
```

In addition, the following features are dropped, besides tiering, unfortunately i have NO IDEA where to check if they were used.

- Block device (bd) xlator
- Decompounder feature
- Crypt xlator
- Symlink-cache xlator
- Stripe feature
- Tiering support (tier xlator and changetimerecorder)
- Glupy

However since no one on our team has heard and/or used those features, we presumed (correctly) that we can do the upgrade without issue - so note that YMMV

## Other useful notes

```
# Trigger heal on all volumes
for i in `gluster volume list`; do gluster volume heal $i; done

## Get the loweset volume version in the cluster
gluster volume get all cluster.op-version

## List all clients connection and their supported version
gluster volume status all clients

## Get the highest supported version in the server cluster
gluster volume get all cluster.max-op-version

# Upgrade the minimum version to 4.1 (YMMV)
gluster volume set all cluster.op-version 40100
```

## Kubernetes note

The kubernetes volume driver is kinda stuck according to the kubernetes version (aka it does not depend on the host client version). However because there is no official listing, this is what we have gathered from our internal infrastructure, YMMV

- k8s v1.20.5 : gluster v7.02
- k8s v1.17.2 : gluster v4.01

Also it seems like the volume driver is currently has no plans of being updated (very concerned for long term roadmap)
https://github.com/gluster/gluster-csi-driver  

## You may want to upgrade gluster clients (after servers)

Note you probably should switch off any workload, and do a restart after installs

```
# Dependencies install steps for ubuntu
sudo apt-get update
sudo apt-get install software-properties-common

# For version 7 
sudo add-apt-repository -y ppa:gluster/glusterfs-7

# For version 9 (alternatively)
sudo add-apt-repository -y ppa:gluster/glusterfs-9

# Update and install the client
sudo apt-get update
sudo apt-get install -y glusterfs-client
```

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/picoded/dockerfiles
