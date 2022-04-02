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
        # Somehow requried for SVG uploads
        php8-simplexml \
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

#
# Setup the workspace
#
RUN mkdir -p /workspace/statamic/
WORKDIR /workspace/

#
# Copy over the entrypoint, and nginx
#
COPY ./entrypoint.sh /workspace/entrypoint.sh
COPY ./nginx-default.conf /etc/nginx/http.d/default.conf
RUN chmod +x /workspace/entrypoint.sh

#
# Increase default PHP upload size limit to 100MB
#
COPY ./upload.ini /etc/php8/conf.d/
COPY ./upload.ini /etc/php8/php-fpm.d/

#
# Project Environment variable configurations
#
ENV \
    #----------------------------------------------------------------------------------------------
    # Project source code loader settings
    #----------------------------------------------------------------------------------------------
    #
    # Configure the proj source type, this support the following options.
    # And downloads into `/workspace/statamic` folder
    #
    # - none : Throws an error if the folder is not setup externally (like docker volumes)
    # - git  : A git URL to clone the project from
    # - tar  : A URL to a TAR file
    # - zip  : A URL to a ZIP file
    #
    # Note that for TAR, and ZIP file - do make sure they are not a "folder" inside an archive.
    # and all assets should directly be at the top level.
    PROJ_SOURCE_TYPE="none" \
    # The URL to download the project data from
    PROJ_SOURCE_URL="https://github.com/statamic/starter-kit-starters-creek.git" \
    # The branch to download the project data from
    PROJ_SOURCE_GIT_BRANCH="master" \
    # If the project was previously initialized, pull updates on startup
    PROJ_SOURCE_UPDATES="true" \
    #----------------------------------------------------------------------------------------------
    # Project auto update settings
    #----------------------------------------------------------------------------------------------
    # Perodically pull for updates, for git/tar/zip deployments
    PROJ_PERODIC_UPDATES="false" \ 
    # Update interval 
    #
    # Specificy this in linux sleep intervals such as '30s', '5m', '24h' 
    # for seconds, minutes or hours respectively.
    #
    # "auto" defaults this to '5m' for git repository. and '12h' for tar/zip
    # this is because git pulls are generally bandwidth efficent. While tar/zip
    # download may cause unneccesary burden on your server bandwidth if done frequently.
    #
    # It is strongly recommended NOT to use this feature for tar/zip. 
    # And trigger the required updates by redeploying the container through CI/CD when possible
    PROJ_PERODIC_UPDATE_INTERVAL="auto" \
    #----------------------------------------------------------------------------------------------
    # Perodic push updates, only works with GIT
    #----------------------------------------------------------------------------------------------
    # Perodically push before pull
    PROJ_GIT_PUSH_BEFORE_PULL="true" \ 
    # Git commit email / user
    PROJ_GIT_PUSH_EMAIL="devops@uilicious.com" \
    PROJ_GIT_PUSH_NAME="statamic docker bot" \
    PROJ_GIT_PUSH_MSG="[automated] perodic commit and push" \
    #----------------------------------------------------------------------------------------------
    # Project initialization settings
    #----------------------------------------------------------------------------------------------
    # --
    # Run the composer install command on startup
    PROJ_RUN_COMPOSER_INSTALL="true" \
    # --
    # If enabled, copy the `PROJ_OVERWRITE_ENV_FILE_PATH` file 
    # and overwrite the /workspace/statamic/.env file.
    # This is useful for overwritting config files via kubernetes
    PROJ_OVERWRITE_ENV_FILE_ENABLE="true" \
    # The file path to check for an overwriting .env config file
    PROJ_OVERWRITE_ENV_FILE_PATH="/workspace/.env" \
    # --
    # Reset the project file permissions on startup
    # this maybe required to resolve common file permission issues
    PROJ_RESET_PROJ_PERMISSION="true" \ 
    # The permission level to overwrite at
    PROJ_RESET_PROJ_PERMISSION_LEVEL="0777" \
    # --
    # Startup the application server using either "nginx" or "artisan"
    # For production workloads, please only use the "nginx" mode.
    PROJ_SERVER_RUN_MODE="nginx" \
    # --
    # Autogenerate the .env file with APP_DEBUG=true, and an APP_KEY if the .env file does not exists
    PROJ_AUTOSETUP_ENV_FILE="true" \
    # Autogenerate the APP_KEY if it does not exists in either the env variables or .env file
    PROJ_AUTOSETUP_APP_KEY="false" \
    #----------------------------------------------------------------------------------------------
    # Docker run / termination behaviour
    #----------------------------------------------------------------------------------------------
    # Tail the various access nad error logs into the docker console log
    PROJ_TAIL_ERROR_LOGS="true" \
    # If additional arguments are passed, overwrite the entry point script in "overwrite" mode
    # alternatively if you want to perform docker chaining, please use "chain" mode
    PROJ_DOCKER_COMMAND_MODE="overwrite"

#
# Example statamic variables, that you need to change / overwrite
# Note that values configured here will take priority over the .env file
#
# ENV APP_DEBUG="" \
#     APP_KEY=""

# The port to run on
EXPOSE 8000

# Fixing stop signals
STOPSIGNAL SIGQUIT

# Trigger the entrypoint script
ENTRYPOINT ["/workspace/entrypoint.sh"]
CMD []