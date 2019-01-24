# uilicious-dockerfile/base

The various folders of Dockerfile's here represent base images, and/or image templates to be extended on.
These containers normally will not have any useful command on their own, and will need to be extended prior to actual usage.

Most of these will be built on alpine-linux containers, for quick reference of supported repository list : [refer to its official packages list](https://pkgs.alpinelinux.org/packages)

Generally they will have the following.

---

# Standard preinstalled packages

The following packages are pre-installed to facilitate the ease of debugging of system via direct access.
This is an intentional trade-off, as a commonly reused base file will mitigate most filesystem bloat concerns

+ bash
+ curl
+ wget
+ vim
+ iputils
+ gettext
+ grep

---

# Standard folders

The following are the standard folders defined in all base containers, and their use case.

# Standard `/entrypoint` folder

Contains the various entrypoint scripts, and/or layers of entrypoint's scripts, defined by the docker
image chain. This is normally simply `/entrypoint/base.sh` but maybe image specific. 

This comes preincluded with `/entrypoint/base.sh` to support the environment variables listed below

Knowledge of this folder is only needed for those looking into maintaining these Dockerfile's / extending them.

# Standard `/application` folder

This generally represents the container specific custom application space. Which does not require persistent storage.

This maybe changed / updated / upgraded over various versions. 
Actual usage will be image specific.

This is also normally the docker `WORKDIR`, or the starting folder if you were to SSH into it.

# Standard `/storage` folder

This generally represents the persistant storage folder.

Also as a guidline, custom configuration folders should be defined in `/storage/config/`

This directory is all that is needed for file backups. Simplifying the process for many deployment scenerios.
Mount, schedule backups, and be done with it.

However for certain repositories it might be more "complicated". Check the README of those image for more details.

Actual usage will be image specific

---

# Standard environment variables

The following envyronment variables will be supported / preconfigured.

# TZ
`ENV TZ=GMT+08`

This represents the timezone of `Singapore`, where we `uilicious` originates from. Until some apocalyptic earth plate
shifting occurs, Feel free to change this to your respective timezone using the format found for `TZ` in the following.

+ https://www.gsp.com/support/virtual/admin/unix/tz/gmt/
+ https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

Note that this configuration is ignored if blank. A legitimate use case would be when mounting `/etc/localtime:/etc/localtime:ro`

# LANGUAGE
`ENV LANG=C.UTF-8`

Sets language to UTF8 : this works in almost all cases, except very region and language specific edge cases.
Not convinced?, let [Joel (on software) Spolsky convince you then](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses)

# ENTRYPOINT_PRESCRIPT
`ENV ENTRYPOINT_PRESCRIPT=""`

Bash script to 'eval' and execute, within the `/entrypoint/base.sh` script.
This is mainly useful for setting up custom apk distribution, on demand within rancher for testing, without going through the much longer process of building new docker containers.

An example use script could be

```
apk add --no-cache ffmpeg
```

Note that for `alpine-base` and their derivatives. Node.js distribution is already included.
This is setup in accordance to: https://nodejs.org/en/download/package-manager/

Runs the following in primer (if not blank) : 
`eval("$APTGET_PRESCRIPT")`

---

# Standard restricted user : appuser

Finally a restricted user/group has been predefined with user/groupid of 1000

By default, container access is not restricted to this user (such configuration will be container specific)

```
# Add the "appuser" with gid 1000 &&
# Add the "appuser" with uid 1000, gid 1000
RUN addgroup -g 1000 -S appuser && \
    adduser -u 1000 -S appuser -G appuser
```
