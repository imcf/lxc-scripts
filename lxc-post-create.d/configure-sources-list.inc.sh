#!/bin/bash

# set up sources.list for APT

echo "deb $MIRROR $SUITE main" > "$TGT_ROOT"/etc/apt/sources.list
