FROM php:8.0.9-fpm-alpine

#
# Add some required PHP "addons"
#
# and other addons required by statamic
# along with a nginx server.
#
RUN apk add --no-cache \
        # Install php, including its opcache, and nginx \
        php8 php8-fpm php8-opcache nginx \
        # Utilities used to download / unzip files \
        unzip wget curl \
        php8-zlib php8-curl \
        # Other PHP addons \
        php8-mbstring php8-xml php8-bcmath \
        # PHP mysql extension \
        php8-mysqli \
        # Image GD support (required for uploading images)
        freetype-dev libjpeg-turbo-dev libpng-dev \
        php8-gd \
        # Git command support \
        git openssh \
        # Bash, because its easier for me to write entryscripts for =D \
        bash

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
# Project Environment variable configurations
#
ENV PROJ_SOURCE_TYPE="none" \
    PROJ_SOURCE_URL="https://github.com/statamic/starter-kit-starters-creek.git" \
    PROJ_SOURCE_GIT_BRANCH="master" \
    PROJ_SOURCE_UPDATES="false" \
    PROJ_RUN_COMPOSER_INSTALL="true" \
    PROJ_COPY_ENV_FILE_PATH="/workspace/.env" \
    PROJ_RESET_STORAGE_PERMISSION="true" \ 
    PROJ_RESET_STORAGE_PATH="/workspace/statamic/storage/" \
    PROJ_RUN_MODE="nginx" \
    PROJ_SETUP_APP_KEY="false"

#
# Default statamic variables, that you need to change / overwrite
#
ENV APP_DEBUG="" \
    APP_KEY=""

# The port to run on
EXPOSE 8000

# Fixing stop signals
STOPSIGNAL SIGQUIT

# Trigger the entrypoint script
ENTRYPOINT ["/workspace/entrypoint.sh"]
CMD []