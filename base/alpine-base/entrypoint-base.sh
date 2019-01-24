#!/bin/bash

# ENTRYPOINT_PRESCRIPT environment variable support
if [ -n "$ENTRYPOINT_PRESCRIPT" ] ; then
   echo "### Running ENTRYPOINT_PRESCRIPT"
   eval "$ENTRYPOINT_PRESCRIPT";
fi

# Chain the execution commands
exec "$@"