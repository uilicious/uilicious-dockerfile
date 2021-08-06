#!/bin/bash

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

if [[ -f "$PROJ_COPY_ENV_FILE_PATH" ]]; then
    echo "## Project ENV file overwrite found at : $PROJ_COPY_ENV_FILE_PATH"
    cp "$PROJ_COPY_ENV_FILE_PATH" "$STATAMIC_DIR/.env"
else
    echo "## [Skipping] Project ENV file overwrite not found at : $PROJ_COPY_ENV_FILE_PATH"
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
#  And some project setup
#
####################################################################################################

# Reset the project permission if needed
if [[ "$PROJ_RESET_STORAGE_PERMISSION" == "true" || "$PROJ_RESET_STORAGE_PERMISSION" == "1" ]]; then
    echo "## Resetting storage permission at : $PROJ_RESET_STORAGE_PATH"
    mkdir -p "$PROJ_RESET_STORAGE_PATH"
    chmod -R 0777 "$PROJ_RESET_STORAGE_PATH"
    echo "## -------------------------------------------------------------------------------- "
fi

# Generate a one time APP_KEY, this maybe ok for statamic, but generally you should generate 
# one on your own, and configure this using APP_KEY

if [[ "$PROJ_SETUP_APP_KEY" == "true" || "$PROJ_SETUP_APP_KEY" == "1" ]]; then
    if [[ -z "$APP_KEY" ]]; then
        echo "## PROJ_SETUP_APP_KEY is enabled, setting up the APP_KEY if required"
        cd "$STATAMIC_DIR"

        if [[ ! -f "$STATAMIC_DIR/.env" ]]; then
            echo "## Initializing empty '$STATAMIC_DIR/.env' file (it does not exists)"

            # Due to a bug as reported at : https://github.com/laravel/framework/issues/33033
            # a valid APP_KEY is needed, to reliably generate a new APP_KEY
            # for obvious reasons, please do not use this APP_KEY (consider it compromised)
            echo "APP_KEY=" > "$STATAMIC_DIR/.env"
            php artisan key:generate
            php artisan config:cache
        else
            if [[ -z "$(grep 'APP_KEY\=..*' .env)" ]];then

                if [[ -z "$(grep 'APP_KEY=' .env)" ]];then
                    echo "## `$STATAMIC_DIR/.env` file exists, but does not have APP_KEY line, appending"
                    echo "" >> $STATAMIC_DIR/.env
                    echo "APP_KEY=" >> $STATAMIC_DIR/.env
                else
                    echo "## `$STATAMIC_DIR/.env` file exists, but has an empty APP_KEY line, updating line"
                fi
                
                php artisan key:generate
                php artisan config:cache
            else 
                echo "## [Skipping] `$STATAMIC_DIR/.env` file exists, with an APP_KEY line, skipping APP_KEY setup"
            fi
        fi
    else
        echo "## [Skipping] PROJ_SETUP_APP_KEY is enabled, but APP_KEY env variable is configured"
    fi
fi

####################################################################################################
#
#  Loading of env file
#
####################################################################################################

#
# For some reason, which I cant seem to figure out why
# the .env file refuses to load - as such this forcefully load the .env
# file into the execution environment variable state instead.
#
# This was a really frusfrating bug, which I unfortunately could not resolve.
# Common advice such as reloading the cache has also been done, but does not seem to work.
# So while not ideal - this is the best I can do.
#
# If anyone knows how to fix the .env file not loading issue, please send a pull request.
#
cd "$STATAMIC_DIR/"
if [[ -f "$STATAMIC_DIR/.env" ]]; then

    echo "## -------------------------------------------------------------------------------- "
    echo "## Loading .env variable file : $STATAMIC_DIR/.env"
    echo "## -------------------------------------------------------------------------------- "

    # Get the env variable file as an array of key=value pairs
    # this only extracts out non-comments and pairs with valid values
    ENV_MULTILINE=($(cat .env | sed 's/#.*//g' | grep '.*\=..*'))

    for ENV_PAIR in "${ENV_MULTILINE[@]}"
    do
        # Get the key value as a pair
        KEY=$(echo "$ENV_PAIR" | cut -d'=' -f 1)
        # VAL=$(echo "$ENV_PAIR" | cut -d'=' -f 2)
        
        echo ">> Processing $ENV_PAIR"
        echo ">> KEY = $KEY"
        echo ">> $ KEY_VAL = ${!KEY}"

        # We only apply values only if existing values is empty
        if [[ -z "${!KEY}" ]]; then
            # Lets export the value
            export $ENV_PAIR
            
            echo ">> export $ENV_PAIR"
        fi
    done

    # Reload the config cache
    php artisan config:cache
fi

####################################################################################################
#
#  Startup the project
#
####################################################################################################

echo "## -------------------------------------------------------------------------------- "
echo "## Starting the application server with the given PROJ_RUN_MODE : $PROJ_RUN_MODE"
echo "## -------------------------------------------------------------------------------- "

# Start the project either through nginx or artisian
if [[ "$PROJ_RUN_MODE" == "nginx" ]]; then

    # PHP-FPM running on localhost port 9000
    php-fpm -d listen=127.0.0.1:9000 &

    # Running the nginx server, in the background (not daemon mode)
    nginx -g "daemon off;" &

elif [[ "$PROJ_RUN_MODE" == "artisan" ]]; then

    # Run via php artisian
    cd "$STATAMIC_DIR"
    php artisan serve --host="0.0.0.0" --port=8000 &

else
    echo "## [FATAL] Unable to start, unknown PROJ_RUN_MODE : $PROJ_RUN_MODE"
    exit 1
fi

####################################################################################################
#
#  Execute chaining and waiting
#
####################################################################################################

# Chain the execution (if any)
exec "$@"

# Enable STOPSIGNAL (such as ctrl-c) to work as designed
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

# Wait for completion of any execution (such as nginx)
wait