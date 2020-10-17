#!/bin/bash

# check on which host distribution and release we are running to avoid surprises

if [ "$HOST_DIST $HOST_REL_NAME" != "Debian buster" ] ; then
    cat << EOT
NOTE: this script is meant for Debian 10 (buster), for other releases (or
even other distributions) it might not work correctly!
EOT
    exit 100
fi
