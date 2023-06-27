#!/bin/bash

# set and export debootstrap-related environment variables

export DISTRIBUTION=debian
export SUITE=buster
export MIRROR="http://ftp.halifax.rwth-aachen.de/$DISTRIBUTION/"

TLD=$(hostname -d | sed 's/.*\.//')
if [ "$TLD" == "ch" ]; then
    echo "Using SWITCH mirror..."
    export MIRROR="http://mirror.switch.ch/ftp/mirror/$DISTRIBUTION/"
fi
