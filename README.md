# Summary

This repository contains a collection of "Dockerfile" for their respective automated build in Docker hub,
found at https://hub.docker.com/u/uilicious/

# Issue filling

Any problems / comments / kudos should be filed at github =)
https://github.com/uilicious/uilicious-dockerfile

---

# Organized Dockerfile

See their respective README for more details. These Dockerfile, typically represents various iterations,
of all my SysAdmin / DevOps docker experiences. Refined for multiple use cases.

**@TODO : fill up description and links**

---

# Some general guidelines / conventions

+ For application servers, Follow the standard environment setup as specified inside (base/README)[https://github.com/picoded/dockerfiles/tree/master/base]
	+ Or extend from it =]

+ For everthing else priotise according to the following : Offical repo, alpine, busybox, debian, alpine-base, ubuntu-base

+ When adding entrypoint scripts, inside the dockerfile link to their respective file directly
	
+ Have a sane default for everything (if possible).
	+ I want things to be deployable without configuration
	+ Exception is for databases, or similar integration

+ **Avoid** defining a volume directory in dockerfile, this makes the docker container much harder to extend due to known file modification issues after a `VOL` command.
	+ instead document the respective volume directory mount points in its README.md
	+ also : with known usage patterns of kubernetes / rancher / etc - the `VOL` directive has no known use case other then documentation
	+ for bug details : https://github.com/moby/moby/issues/12779
	+ and : https://stackoverflow.com/questions/26145351/why-doesnt-chown-work-in-dockerfile

---

# License 

`MIT License`

This is an obvious choice due to the highly public nature of these Docker repo's and how easy, 
or commonly the scripts can be replicated.

For most of the Dockerfiles, I wager that someone out there has something similar.

Hopefully mine is better, Cheers!

Best Regards,
Eugene Cheah - CTO @ Uilicious.com
