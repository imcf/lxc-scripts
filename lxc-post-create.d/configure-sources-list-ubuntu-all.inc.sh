#!/bin/bash

# set up sources.list for APT

echo "deb $MIRROR $SUITE main universe multiverse" > "$TGT_ROOT"/etc/apt/sources.list
