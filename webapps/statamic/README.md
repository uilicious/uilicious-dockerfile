# Statamic Docker Containers

Prebuilt docker container, adjusted specifically for common statamic deployment use cases, with control panel.

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

## Docker environment variables

| Docker ENV Variable              | Possible Values                               | Default Value         | Description                                                                                                                                                                      |
|----------------------------------|-----------------------------------------------|-----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PROJ_SOURCE_TYPE                 | none, git, tar, zip                           | none                  | If Enabled - Download from a remote repository (or file) on startup, into the `/workspace/statamic` directory. Runs either as "none" (disabled), "git" URL, or "tar" / "zip" URL |
| PROJ_SOURCE_URL                  | Valid URL for git/tar/zip mode                | (starter-kit-git-url) | URL to download or pull updates                                                                                                                                                  |
| PROJ_SOURCE_GIT_BRANCH           | git branch to clone, for git mode             | master                | git mode only - the git branch to checkout / pull from                                                                                                                           |
| PROJ_SOURCE_UPDATES              | true, false                                   | true                  | If Enabled - Pull updates, if the project is already initialize                                                                                                                  |
| PROJ_RUN_COMPOSER_INSTALL        | true, false                                   | true                  | If Enabled - Run `composer install` on container startup                                                                                                                         |
| PROJ_OVERWRITE_ENV_FILE_ENABLE   | true, false                                   | true                  | If Enabled - Overwrite the project `/workspace/statamic/.env` with the specified file, if it exists. This is useful for overwriting config files in kubernetes.                  |
| PROJ_OVERWRITE_ENV_FILE_PATH     | Valid file path, to copy the `.env` file from | /workspace/.env       | The file path to check, to overwrite inside the project (if present)                                                                                                             |
| PROJ_RESET_PROJ_PERMISSION       | true, false                                   | true                  | If Enabled - Reset the project files permission, on startup                                                                                                                      |
| PROJ_RESET_PROJ_PERMISSION_LEVEL | Valid chmod permission values                 | 0777                  | Chmod value to overwrite with on startup                                                                                                                                         |
| PROJ_SERVER_RUN_MODE             | nginx, artisian                               | nginx                 | Server run mode to use, for production please use only the "nginx" mode                                                                                                          |
| PROJ_AUTOSETUP_ENV_FILE          | true, false                                   | true                  | If Enabled - Automatically setup the site .env file, if it does not exists (skips if APP_DEBUG, and APP_KEY is configured)                                                       |
| PROJ_AUTOSETUP_APP_KEY           | true, false                                   | false                 | If Enabled - Generate a new APP_KEY, if its not configured in the .env file (or environment value)                                                                               |
| PROJ_TAIL_ERROR_LOGS             | true, false                                   | true                  | If Enabled - At the end of the server startup, tail the various nginx error logs, into the docker container stdout                                                               |
| PROJ_DOCKER_COMMAND_MODE         | overwrite, chain                              | overwrite             | How docker command arguments should be handled, this is only useful for debugging purposes mostly.                                                                               |

## Docker file structure

- `/workspace/statamic/` : Directory for the statamic site
- `/workspace/.env` : to copy and overwrite `/workspace/statamic/.env` if present with `PROJ_OVERWRITE_ENV_FILE_ENABLE` enabled

## [@TODO] Production deployment options

**Pull the GIT repository, on docker startup**

**Extend the docker container with the files**

## General Disclaimer

In event that an official statamic docker container is released and maintain, it is highly recommended to validate your use case against the official container (instead of this container) as we have no long term plans to maintain this container on a regular basis, or anything beyond our use cases. This is opensourced for refrence for you to either extend or build your own container. YMMV.