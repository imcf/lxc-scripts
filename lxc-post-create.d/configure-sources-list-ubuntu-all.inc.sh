#!/bin/bash

# set up sources.list for APT

for CUR_SUITE in "$SUITE $SUITE-updates $SUITE-security" ; do
    echo "deb $MIRROR $CUR_SUITE main universe multiverse" >> "$TGT_ROOT"/etc/apt/sources.list
done
