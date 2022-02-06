#!/bin/bash

# check on which host distribution and release we are running to avoid surprises

EXP_DIST="Debian"
EXP_REL="11"
EXP_REL_NAME="bullseye"

if [ "$HOST_DIST $HOST_REL_NAME" != "$EXP_DIST $EXP_REL_NAME" ] ; then
    cat << EOT
NOTE: this script is meant for $EXP_DIST $EXP_REL ($EXP_REL_NAME), for other releases (or
even other distributions) it might not work correctly!

Press <ENTER> to continue or <Ctrl>+<C> to abort!
EOT
    read
fi
