# Statamic Docker Containers

Prebuilt docker container, adjusted specifically for common statamic deployment use cases, with control panel.

- https://hub.docker.com/repository/docker/uilicious/statamic
- https://github.com/uilicious/uilicious-dockerfile/tree/master/webapps/statamic

## Quick Dev Deployment Patterns

**Running on local dev**

If you have a local dev copy of the statamic files, you would like to "test" deploy within a docker container, you can run the following

```bash
#
# This would mount the current folder, into the statamic docker container.
# And reroute the localhost 8000 port into the docker container port 8000.
#
# Note this will automatically create a `.env` file with APP_DEBUG=true, 
# if it does not exists in the current folder. Peform `composer install`
# And reset its permission to 0777
#
# -it : Runs in interactive mode, logs directly to the console, and terminate 
#       the container when you close the console
#
sudo docker run -it \
    -v "$(pwd):/workspace/statamic" \
    -p 8000:8000 \
    uilicious/statamic 
```

**Quickly Previewing a GIT repo locally**

If you find a statamic GIT repo, you would like to quickly preview locally. You can run the following instead.

```bash
#
# Startsup a docker container, on localhost port 8000
# which clones a git repository, and does all the  
# initialization requried to do a quick preview
#
sudo docker run -it \
    -e PROJ_SOURCE_TYPE="git" \
    -e PROJ_SOURCE_URL="https://github.com/statamic/starter-kit-starters-creek.git" \
    -e PROJ_SOURCE_GIT_BRANCH="master" \
    -p 8000:8000 \
    uilicious/statamic 
```

**With various environment variable flag**

```bash
#
# Disables the APP_DEBUG (which defaults to true in this container)
# And include your site unique app key, and statamic key
#
sudo docker run -it \
    -e PROJ_SOURCE_TYPE="git" \
    -e PROJ_SOURCE_URL="<your-project-git-URL>" \
    -e PROJ_SOURCE_GIT_BRANCH="master" \
    -e APP_DEBUG="false" \
    -e APP_KEY="<site-unique-appkey>" \
    -e STATAMIC_LICENSE_KEY="<statamic-unique-key>" \
    -p 8000:8000 \
    uilicious/statamic 
```

## Docker environment variables

**Startup settings** 

| Docker ENV Variable              | Possible Values                               | Default Value         | Description                                                                                                                                                                      |
|----------------------------------|-----------------------------------------------|-----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PROJ_SOURCE_TYPE                 | none, git, tar, zip                           | none                  | If Enabled - Download from a remote repository (or file) on startup, into the `/workspace/statamic` directory. Runs either as "none" (disabled), "git" URL, or "tar" / "zip" URL |
| PROJ_SOURCE_URL                  | Valid URL for git/tar/zip mode                | (starter-kit-git-url) | URL to download or pull updates                                                                                                                                                  |
| PROJ_SOURCE_GIT_BRANCH           | git branch to clone, for git mode             | master                | git mode only - the git branch to checkout / pull from                                                                                                                           |
| PROJ_SOURCE_UPDATES              | true, false                                   | true                  | If Enabled - Pull updates, if the project is already initialize                                                                                                                  |

**Auto Update settings** 

| Docker ENV Variable              | Possible Values                               | Default Value         | Description                                                                                                                                                                      |
|----------------------------------|-----------------------------------------------|-----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PROJ_PERODIC_UPDATES             | true, false                                   | false                 | Perodically pull updates from the PROJ_SOURCE_URL for changes                                                                                                                    |
| PROJ_PERODIC_UPDATE_INTERVAL     | auto, 5m, 60s, 24h (valid time based value)   | auto                  | Auto defaults to 5m for git repository, and 12h for tar/zip                                                                                                                      |
| PROJ_GIT_PUSH_BEFORE_PULL        | true, false                                   | true                  | Only for git, enable push before pull updates                                                                                                                                    |
| PROJ_GIT_PUSH_EMAIL              | email address string                          | devops@uilicious.com  | Git email, to use for the commit                                                                                                                                                 |
| PROJ_GIT_PUSH_NAME               | name of user/account                          | statamic docker bot   | Git name, to use for the commit                                                                                                                                                  |
| PROJ_GIT_PUSH_MSG                | git message to use to commit                  | periodic commit ...   | Git message, to use for the commit                                                                                                                                               |

**Statamic runtime settings** 

| Docker ENV Variable              | Possible Values                               | Default Value         | Description                                                                                                                                                                      |
|----------------------------------|-----------------------------------------------|-----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PROJ_RUN_COMPOSER_INSTALL        | true, false                                   | true                  | If Enabled - Run `composer install` on container startup                                                                                                                         |
| PROJ_OVERWRITE_ENV_FILE_ENABLE   | true, false                                   | true                  | If Enabled - Overwrite the project `/workspace/statamic/.env` with the specified file, if it exists. This is useful for overwriting config files in kubernetes.                  |
| PROJ_OVERWRITE_ENV_FILE_PATH     | Valid file path, to copy the `.env` file from | /workspace/.env       | The file path to check, to overwrite inside the project (if present)                                                                                                             |
| PROJ_RESET_PROJ_PERMISSION       | true, false                                   | true                  | If Enabled - Reset the project files permission, on startup                                                                                                                      |
| PROJ_RESET_PROJ_PERMISSION_LEVEL | Valid chmod permission values                 | 0777                  | Chmod value to overwrite with on startup                                                                                                                                         |
| PROJ_SERVER_RUN_MODE             | nginx, artisan                                | nginx                 | Server run mode to use, for production please use only the "nginx" mode                                                                                                          |
| PROJ_AUTOSETUP_ENV_FILE          | true, false                                   | true                  | If Enabled - Automatically setup the site .env file, if it does not exists (skips if APP_DEBUG, or APP_KEY is configured)                                                        |
| PROJ_AUTOSETUP_APP_KEY           | true, false                                   | false                 | If Enabled - Generate a new APP_KEY, if its not configured in the .env file (or environment value)                                                                               |
| PROJ_TAIL_ERROR_LOGS             | true, false                                   | true                  | If Enabled - At the end of the server startup, tail the various nginx error logs, into the docker container stdout                                                               |
| PROJ_DOCKER_COMMAND_MODE         | overwrite, chain                              | overwrite             | How docker command arguments should be handled, this is only useful for debugging purposes mostly.                                                                               |

## Docker file structure

- `/workspace/statamic/` : Directory for the statamic site
- `/workspace/.env` : to copy and overwrite `/workspace/statamic/.env` if present with `PROJ_OVERWRITE_ENV_FILE_ENABLE` enabled

## Production deployment options

**Note: Enabling HTTPS behind a proxy**

It is common for a kubernetes / docker cluster setup to have a HTTPS-to-HTTP reverse proxy before the application container.
To configure the statamic site to properlly give URL links in HTTPS you should add the following to your statamic site `routes/web.php`

```php
// ----------------------------------------------------
// Adding HTTPS schema / proxy url overwrite options
//
// Modified from: https://cylab.be/blog/122/using-https-over-a-reverse-proxy-in-laravel
// ----------------------------------------------------
$app_url = config("app.url");
if (!empty($app_url)) {
    // URL::forceRootUrl($app_url);
    $schema = explode(':', $app_url)[0];
    URL::forceScheme($schema);
}
// ----------------------------------------------------
```

Once done, make sure to configure the env variables required for `APP_URL` and `ASSET_URL `to include the `https://` prefix

**Pull the GIT repository, on docker startup, push GIT changes on editor updates**

The following would get a statamic server up and running, which will automatically push any changes back into the repository.

```
sudo docker run -it \
    -e PROJ_SOURCE_TYPE="git" \
    -e PROJ_SOURCE_URL="<your-project-git-URL>" \
    -e PROJ_SOURCE_GIT_BRANCH="<git-branch>" \
    -e APP_DEBUG="false" \
    -e APP_KEY="<site-unique-appkey>" \
    -e STATAMIC_LICENSE_KEY="<statamic-license-key>" \
    -e STATAMIC_GIT_ENABLED="true" \
    -e STATAMIC_GIT_PUSH="true" \
    -e APP_URL="https://<site-url>" \
    -e ASSET_URL="https://<site-url>" \
    -p 8000:8000 \
    uilicious/statamic 
```

Note: This does not pull any updates from the git repository automatically, you should get your git repository to trigger a "git pull" within the container "/workspace/statamic" folder respectively.

**Extend the docker container with your files**

@TODO

## I want to build my own container (not extend this container)

The way the entrypoint script works is highly oppinionated, and has been adjusted for my personal use case - so i understand if you would like to do it differently.

What your looking for probably is the list of dependencies you would need to get things up and running (without 3 whole days of trial and error), so the following is what we used on alpine to make this work for most use cases, and what you can base your builds on.

```docker
FROM alpine:3.14

#
# Add some required PHP "addons"
#
# and other addons required by statamic
# along with a nginx server.
#
RUN apk add --no-cache \
        # Install php, and nginx \
        php8 php8-cli php8-common php8-fpm nginx \
        # Install dependency library for opcache \
        pcre-dev \
        # Utilities used to download / unzip files \
        unzip wget curl \
        # Image GD support (required for uploading images)
        freetype-dev libjpeg-turbo-dev libpng-dev gd \
        # Git command support \
        git openssh \
        # Bash, because its easier for me to write entryscripts for =D \
        # Vim, is because its my prefer editor to debug things =X \
        bash vim \
        # PHP opcache optimization
        php8-opcache \
        # PHP mysql extension \
        php8-mysqli \
        # PHP GD image manipulation support
        php8-gd php8-exif \
        # Required to be able to pull updates (download)
        php8-zip php8-zlib php8-curl \
        # Other PHP addons, I do not know what they maybe used for specifically \
        # But errors maybe thrown in the installation / setup process otherwise \
        php8-mbstring php8-xml php8-bcmath \
        php8-pdo php8-tokenizer php8-xml \
        php8-pcntl php8-phar php8-dom php8-xmlwriter \
        php8-fileinfo php8-session

# Create the symlink for php to php8 (as alpine does not support this)
RUN ln -s $(which php8) /usr/bin/php && \
    ln -s $(which php-fpm8) /usr/bin/php-fpm

# In addition we need to run the relevent docker-php-ext install
# NOTE: Due to the current issue of PHP8 official container, and some of the extensions listed here
#       we are depending on the alpine packages instead.
#
# RUN docker-php-ext-install \
#         opcache zlib curl mbstring xml bcmath gd mysqli pdo pdo_mysql tokenizer xml pcntl

#
# Install PHP composer
# Version and SHA can be found here : https://getcomposer.org/download/
#
ENV COMPOSER_VERSION 2.1.5
ENV COMPOSER_CHECKSUM be95557cc36eeb82da0f4340a469bad56b57f742d2891892dcb2f8b0179790ec
RUN wget -q https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar && \
    echo "$COMPOSER_CHECKSUM  composer.phar" | sha256sum -c - && \
    mv composer.phar /usr/bin/composer && \
    chmod +x /usr/bin/composer
```

You can find the above inside our dockerfile, and if we have a module missing for a use case - just let me know in a pull request, and i will add it.

## General Disclaimer

In event that an official statamic docker container is released and maintained, it is highly recommended to validate your use case against the official container (instead of this container) as we have no long term plans to maintain this container on a regular basis, or anything beyond our use cases. This is opensourced for refrence for you to either extend or build your own container. YMMV.