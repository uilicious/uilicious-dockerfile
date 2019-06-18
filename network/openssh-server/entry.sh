#!/bin/sh

# Password safety
if [ "$SSH_PASS" == "password_pls_change" ] 
then
	echo "!!! -- FATAL ERROR -- !!! : Default password detected, please configure SSH_PASS environment variable"
	sleep 10
	exit 1
fi

# Setting up ssh-keygen
ssh-keygen -A

# Setup the user and pass
echo "$SSH_USER:$SSH_PASS" | chpasswd

# And run sshd, while passing arguments over
exec "$@"
