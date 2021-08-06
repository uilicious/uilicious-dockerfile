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
        # Other PHP addons, I do not know what they maybe used for specifically \
        # But errors maybe thrown in the installation / setup process otherwise \
        php8-zlib php8-curl \
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
# Project Environment variable configurations
#
ENV PROJ_SOURCE_TYPE="none" \
    PROJ_SOURCE_URL="https://github.com/statamic/starter-kit-starters-creek.git" \
    PROJ_SOURCE_GIT_BRANCH="master" \
    PROJ_SOURCE_UPDATES="false" \
    PROJ_RUN_COMPOSER_INSTALL="true" \
    PROJ_COPY_ENV_FILE_ENABLE="true" \
    PROJ_COPY_ENV_FILE_PATH="/workspace/.env" \
    PROJ_RESET_PROJ_PERMISSION="true" \ 
    PROJ_RESET_PROJ_PERMISSION_LEVEL="0777" \
    PROJ_RUN_MODE="nginx" \
    PROJ_SETUP_APP_KEY="false" \
    PROJ_TAIL_ERROR_LOGS="true"

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