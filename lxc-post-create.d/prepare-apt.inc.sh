#!/bin/bash

# either run 'apt-get update' if no local package cache was configured or copy the
# package archive and apt lists to the target root and build up the cache there
if [ -z "$LOCALPKGS" ] ; then
    chroot $TGT_ROOT apt-get update
else
    echo "Using local packges and lists: $LOCALPKGS"
    cp "$LOCALPKGS/lists/"* "$TGT_ROOT/var/lib/apt/lists/"
    cp "$LOCALPKGS/archives/"*.deb "$TGT_ROOT/var/cache/apt/archives/"
    chroot $TGT_ROOT apt-cache gencaches
fi
