#!/bin/bash

# Bash STRICT mode
set -eo pipefail
IFS=$'\n\t'

####################################################################################################
#
#  Execute the overwriting command if given
#
####################################################################################################

# Use the command if given instead, in overwrite mode
if [[ "$PROJ_DOCKER_COMMAND_MODE" == "overwrite" ]]; then
    if [ $# -gt 0 ]; then
        # run the overwrite command
        exec "$@"
        exit 0
    fi
fi

####################################################################################################
#
#  ENV variable configs
#
####################################################################################################

# Statamic dir to download into
STATAMIC_DIR="/workspace/statamic"

####################################################################################################
#
#  Utility functions
#
####################################################################################################

# Pulling updates of repository files
function update_statamic_files {
    
    # Clone into directory
    if [[ "$PROJ_SOURCE_TYPE" == "none" ]]; then
        # Silently terminate if source type is disabled
        return 0
    elif [[ "$PROJ_SOURCE_TYPE" == "git" ]]; then

        # Pull git updates
        echo "## Pulling git updates from from : $PROJ_SOURCE_URL"

        cd "$STATAMIC_DIR"
        git remote set-url origin "$PROJ_SOURCE_URL"
        git submodule foreach --recursive git reset --hard
        git pull "$PROJ_SOURCE_URL" .
        git submodule foreach --recursive git reset --hard

    elif [[ "$PROJ_SOURCE_TYPE" == "tar" ]]; then

        echo "## Downloading TAR file from : $PROJ_SOURCE_URL"

        # Initialize and directly download and untar
        mkdir -p "$STATAMIC_DIR"
        curl --show-error --location "$PROJ_SOURCE_URL" | tar -xf - -C "$STATAMIC_DIR"

    elif [[ "$PROJ_SOURCE_TYPE" == "zip" ]]; then

        echo "## Downloading ZIP file from : $PROJ_SOURCE_URL"

        # Initialize the dir first
        mkdir -p "$STATAMIC_DIR"

        # Reset the tmp directory if needed
        mkdir -p "/tmp/statamic-downloader/"
        rm -rf "/tmp/statamic-downloader/"
        mkdir -p "/tmp/statamic-downloader/files"
        
        # Inside the tmp dir
        cd /tmp/statamic-downloader

        # Download and unpack into the destination folder
        wget -O package.zip "$PROJ_SOURCE_URL"
        unzip -d "$STATAMIC_DIR" package.zip 
        
        # Reset the tmp folder
        rm -rf "/tmp/statamic-downloader/"

    else
        echo "## [FATAL] Unable to fetch statamic files, unknown source type : $PROJ_SOURCE_TYPE"
        exit 1
    fi

}

####################################################################################################
#
#  Initialize the repository OR pull updates
#
####################################################################################################

# Initialize the statamic directory if needed
if [[ ! -f "$STATAMIC_DIR/server.php" ]]; then
    echo "## Statamic directory is missing server.php, initializing : $STATAMIC_DIR"

    # Clone into directory
    if [[ "$PROJ_SOURCE_TYPE" == "none" ]]; then

        # Terminating the 
        echo "## Initializing of statamic directory is disabled : $PROJ_SOURCE_TYPE"
        exit 1

    elif [[ "$PROJ_SOURCE_TYPE" == "git" ]]; then

        echo "## Cloning git directory from : $PROJ_SOURCE_URL"

        mkdir -p "$STATAMIC_DIR"
        cd "$STATAMIC_DIR"
        git clone -b "$PROJ_SOURCE_GIT_BRANCH" --recurse-submodules "$PROJ_SOURCE_URL" "$STATAMIC_DIR"

    elif [[ "$PROJ_SOURCE_TYPE" == "tar" ]]; then

        # Pull in tar files
        update_statamic_files

    elif [[ "$PROJ_SOURCE_TYPE" == "zip" ]]; then

        # Pull in zip files
        update_statamic_files

    else
        echo "## Unable to set statamic directory, unknown source type : $PROJ_SOURCE_TYPE"
    fi


else
    echo "## Statamic directory is already initialized at : $STATAMIC_DIR"

    # Pull file updates if its configured
    if [[ "$PROJ_SOURCE_UPDATES" == "true" || "$PROJ_SOURCE_UPDATES" == "1" ]]; then
        echo "## Fetching source updates for : $STATAMIC_DIR"
        update_statamic_files
    fi
fi

if [[ "$PROJ_SOURCE_TYPE" == "git" ]]; then
    echo "## -------------------------------------------------------------------------------- "
    echo "## Getting current GIT project version"
    echo "## -------------------------------------------------------------------------------- "
    cd "$STATAMIC_DIR"
    git rev-parse HEAD
fi

echo "## -------------------------------------------------------------------------------- "
echo "## Listing files inside statamic directory"
echo "## -------------------------------------------------------------------------------- "
ls -alh "$STATAMIC_DIR"
echo "## -------------------------------------------------------------------------------- "

####################################################################################################
#
#  Copy env file path (if present)
#
####################################################################################################

# Copy env file if present and enabled
if [[ "$PROJ_OVERWRITE_ENV_FILE_ENABLE" == "true" || "$PROJ_OVERWRITE_ENV_FILE_ENABLE" == "1" ]]; then
    cd "$STATAMIC_DIR/"

    if [[ -f "$PROJ_OVERWRITE_ENV_FILE_PATH" ]]; then
        echo "## Project ENV file overwrite found at : $PROJ_OVERWRITE_ENV_FILE_PATH"
        cp "$PROJ_OVERWRITE_ENV_FILE_PATH" "$STATAMIC_DIR/.env"
        chmod "$PROJ_RESET_PROJ_PERMISSION_LEVEL" "$STATAMIC_DIR/.env"
    else
        echo "## [Skipping] Project ENV file overwrite not found at : $PROJ_OVERWRITE_ENV_FILE_PATH"
    fi
fi

####################################################################################################
#
#  Perform composer install
#
####################################################################################################

# Files are updated, lets do a composer install ?
if [[ "$PROJ_RUN_COMPOSER_INSTALL" == "true" || "$PROJ_RUN_COMPOSER_INSTALL" == "1" ]]; then
    echo "## Performing composer install : $STATAMIC_DIR"
    echo "## -------------------------------------------------------------------------------- "
    cd "$STATAMIC_DIR"
    composer install
fi

####################################################################################################
#
#  Startup the project
#
####################################################################################################

echo "## -------------------------------------------------------------------------------- "
echo "## Starting the application server with the given PROJ_SERVER_RUN_MODE : $PROJ_SERVER_RUN_MODE"
echo "## -------------------------------------------------------------------------------- "

# Start the project either through nginx or artisian
if [[ "$PROJ_SERVER_RUN_MODE" == "nginx" ]]; then

    # PHP-FPM running on localhost port 9000
    php-fpm -d listen=127.0.0.1:9000 &

    # Running the nginx server, in the background (not daemon mode)
    nginx -g "daemon off;" &

elif [[ "$PROJ_SERVER_RUN_MODE" == "artisan" ]]; then

    # Run via php artisian
    cd "$STATAMIC_DIR"
    php artisan serve --host="0.0.0.0" --port=8000 &

else
    echo "## [FATAL] Unable to start, unknown PROJ_SERVER_RUN_MODE : $PROJ_SERVER_RUN_MODE"
    exit 1
fi

####################################################################################################
#
#  And some project setup
#
####################################################################################################

# Reset the project permission if needed
if [[ "$PROJ_RESET_PROJ_PERMISSION" == "true" || "$PROJ_RESET_PROJ_PERMISSION" == "1" ]]; then
    echo "## Resetting project permission at : $STATAMIC_DIR to $PROJ_RESET_PROJ_PERMISSION_LEVEL"
    chmod -R $PROJ_RESET_PROJ_PERMISSION_LEVEL "$STATAMIC_DIR"
    chmod -R +x "$STATAMIC_DIR"
    echo "## -------------------------------------------------------------------------------- "
fi

# Setup the .env file, if it does not exist
if [[ "$PROJ_AUTOSETUP_ENV_FILE" == "true" || "$PROJ_AUTOSETUP_ENV_FILE" == "1" ]]; then
    echo "## [AUTOSETUP] PROJ_AUTOSETUP_ENV_FILE=$PROJ_AUTOSETUP_ENV_FILE"
    if [[ ! -f "$STATAMIC_DIR/.env" ]]; then

        if [[ ! -z "$APP_DEBUG"  || ! -z "$APP_KEY" ]]; then

            echo "## [AUTOSETUP] Skipping '$STATAMIC_DIR/.env' setup"
            echo "## [AUTOSETUP] as either APP_DEBUG and APP_KEY env variable is configured"
            
        else

            echo "## [AUTOSETUP] Initializing empty '$STATAMIC_DIR/.env' file (it does not exists)"
            echo "## [AUTOSETUP] WARNING: This should only be done for development builds, as APP_DEBUG=true"
            echo "## [AUTOSETUP]          AKA - Please configure .env for production/server use cases"
            echo "## [AUTOSETUP]          unless you want your server to be hacked."

            echo "APP_DEBUG=true" > "$STATAMIC_DIR/.env"
            echo "APP_KEY=" >> "$STATAMIC_DIR/.env"

            php artisan key:generate
            php artisan config:cache

        fi
    else
        echo "## [AUTOSETUP] Skipping '$STATAMIC_DIR/.env' setup, as it already exists"
    fi
fi

# Generate a one time APP_KEY, this maybe ok for statamic, but generally you should generate 
# one on your own, and configure this using APP_KEY
if [[ "$PROJ_AUTOSETUP_APP_KEY" == "true" || "$PROJ_AUTOSETUP_APP_KEY" == "1" ]]; then
    if [[ -z "$APP_KEY" ]]; then
        echo "## [AUTOSETUP] PROJ_AUTOSETUP_APP_KEY is enabled, setting up the APP_KEY if required"
        cd "$STATAMIC_DIR"

        if [[ ! -f "$STATAMIC_DIR/.env" ]]; then
            echo "## [AUTOSETUP] Initializing empty '$STATAMIC_DIR/.env' file (it does not exists)"

            # Due to a bug as reported at : https://github.com/laravel/framework/issues/33033
            # a valid APP_KEY is needed, to reliably generate a new APP_KEY
            # for obvious reasons, please do not use this APP_KEY (consider it compromised)
            echo "APP_KEY=" > "$STATAMIC_DIR/.env"
            php artisan key:generate
            php artisan config:cache
        else
            echo "## [AUTOSETUP] '$STATAMIC_DIR/.env' file exists, checking for APP_KEY"

            if [[ -z "$(cat $STATAMIC_DIR/.env | grep '^APP_KEY\=..*')" ]];then

                if [[ -z "$(cat $STATAMIC_DIR/.env | grep '^APP_KEY=')" ]];then
                    echo "## [AUTOSETUP] `$STATAMIC_DIR/.env` file exists, but does not have APP_KEY line, appending"
                    echo "" >> $STATAMIC_DIR/.env
                    echo "APP_KEY=" >> $STATAMIC_DIR/.env
                else
                    echo "## [AUTOSETUP] `$STATAMIC_DIR/.env` file exists, but has an empty APP_KEY line, updating line"
                fi
                
                php artisan key:generate
                php artisan config:cache
            else 
                echo "## [AUTOSETUP][Skipping] `$STATAMIC_DIR/.env` file exists, with an APP_KEY line, skipping APP_KEY setup"
            fi
        fi
    else
        echo "## [AUTOSETUP][Skipping] PROJ_AUTOSETUP_APP_KEY is enabled, but APP_KEY env variable is configured"
    fi
fi

####################################################################################################
#
#  Performing a localhost curl
#
####################################################################################################

# Doing a localhost test curl
echo "## -------------------------------------------------------------------------------- "
echo "## [Post Server Start] Performing initial localhost curl (kick start any PHP script needed)"
sleep 5s
curl -s --head http://localhost:8000/index.php >> /dev/null || true

# Reset the project permission if needed
if [[ "$PROJ_RESET_PROJ_PERMISSION" == "true" || "$PROJ_RESET_PROJ_PERMISSION" == "1" ]]; then
    echo "## [Post Server Start] Resetting project permission at : $STATAMIC_DIR to $PROJ_RESET_PROJ_PERMISSION_LEVEL"
    chmod -R $PROJ_RESET_PROJ_PERMISSION_LEVEL "$STATAMIC_DIR"
    chmod -R +x "$STATAMIC_DIR"

    php artisan cache:clear
    php artisan config:cache
    sleep 5s
    echo "## -------------------------------------------------------------------------------- "
fi

####################################################################################################
#
#  Execute chaining any additional commands
#
####################################################################################################

# Chain the execution (if any)
exec "$@"

####################################################################################################
#
#  Waiting for server to be ready
#
####################################################################################################

# Enable STOPSIGNAL 
# (such as ctrl-c) to work as designed
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

# HTTP Connectivity Test
echo "## -------------------------------------------------------------------------------- "
echo "## [Post Server Start] Performing localhost curl (waiting for it to be ready)"
echo "##                     WARNING: If your .env file is misconfigured, the container"
echo "##                     will be stuck in this 'waiting for it be ready' state"

printf "%s" "[http://localhost:8000/] ."
until curl -s --head --fail http://localhost:8000/ &> /dev/null; 
do 
    printf "%c" "."
    sleep 2
done
echo ""
echo "[http://localhost:8000/] READY"
curl -s --head --fail http://localhost:8000/ || true

echo "## -------------------------------------------------------------------------------- "
echo "## OK - Server should be up and running now"
echo "##      Note: statamic may take sometime to initialize all the assets"
echo "##      and you may see 404 / 500 / chmod errors till they are ready"
echo "## -------------------------------------------------------------------------------- "

####################################################################################################
#
#  Waiting for server termination
#
####################################################################################################

if [[ "$PROJ_TAIL_ERROR_LOGS" == "true" || "$PROJ_TAIL_ERROR_LOGS" == "1" ]]; then
    # Tail the error logs if needed
    cd "/var/log"
    tail -f /var/log/nginx/access.log /var/log/nginx/error.log /var/log/php8/error.log &
fi

# Wait for completion of any execution (such as nginx)
wait
