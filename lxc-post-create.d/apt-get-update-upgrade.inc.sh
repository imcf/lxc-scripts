#!/bin/bash

chroot "$TGT_ROOT" "$EATMYDATA" apt-get update
chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y dist-upgrade
