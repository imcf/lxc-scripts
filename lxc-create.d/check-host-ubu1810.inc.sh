#!/bin/bash

if [ "$HOST_DIST $HOST_REL" != "Ubuntu 18.10" ] ; then
    cat << EOT
NOTE: this script is meant for Ubuntu 18.10 (cosmic), for other releases (or
even other distributions) it might not work correctly!
EOT
    exit 100
fi
