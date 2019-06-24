#!/bin/bash

if [ "$HOST_DIST $HOST_REL" != "Ubuntu 17.04" ] ; then
    cat << EOT
NOTE: this script is meant for Ubuntu 17.04 (zesty), for other releases (or
even other distributions) it might not work correctly!
EOT
    exit 100
fi
