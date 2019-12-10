!/bin/bash

# ENTRYPOINT_PRESCRIPT environment variable support

if [ -n "$CONFIG_POSTSCRIPT" ]; then 
	echo "### CONFIG_POSTSCRIPT"
	eval "$CONFIG_POSTSCRIPT";
	  # Chain the execution commands
fi 


exec "$@"'