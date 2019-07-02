#!/bin/bash

# run a full APT update/upgrade cycle:

chroot "$TGT_ROOT" "$EATMYDATA" apt-get update
chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y dist-upgrade
