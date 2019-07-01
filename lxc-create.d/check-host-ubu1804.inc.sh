#!/bin/bash

# check on which host distribution and release we are running to avoid surprises

if [ "$HOST_DIST $HOST_REL" != "Ubuntu 18.04" ] ; then
    cat << EOT
NOTE: this script is meant for Ubuntu 18.04 (bionic), for other releases (or
even other distributions) it might not work correctly!
EOT
    exit 100
fi
