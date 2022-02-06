#!/bin/bash

# set up sources.list for APT
TGT_SOURCESLIST="$TGT_ROOT"/etc/apt/sources.list
echo > "$TGT_SOURCESLIST"

for CUR_SUITE in "$SUITE $SUITE-updates $SUITE-security" ; do
    echo "deb $MIRROR $CUR_SUITE main universe multiverse" >> "$TGT_SOURCESLIST"
done
