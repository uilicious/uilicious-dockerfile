# uilicious/alpine-openjdk

https://hub.docker.com/r/uilicious/alpine-openjdk/
https://github.com/uilicious/uilicious-dockerfile/tree/master/base/alpine-openjdk

Base alpine container (With openjdk8 preinstalled), normalised to conform to our requirements 
as outlined inside the [base/README](https://github.com/uilicious/uilicious-dockerfile/tree/master/base).

## Standard environment variables

+ `TZ=GMT+08`               : Default system timezone (Singapore)
+ `LANG=en_US.UTF-8`        : Used to configure OS language support
+ `ENTRYPOINT_PRESCRIPT=""` : Commands to execute at the start of `/entrypoint/base.sh`

See [base/README](https://github.com/uilicious/uilicious-dockerfile/tree/master/base) for more details.

## Standard predefined folders

+ `/entrypoint` : Docker container entrypoint scripts
+ `/appspace`   : Container specific application folder, not meant for persistent storage
+ `/storage `   : Container specific persistant storage folder

See [base/README](https://github.com/uilicious/uilicious-dockerfile/tree/master/base) for more details.

## Issue filling

Any problems / comments / kudos should be filed at github =)
https://hub.docker.com/r/uilicious/
