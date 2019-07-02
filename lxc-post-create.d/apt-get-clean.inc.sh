#!/bin/bash

# clean up downloaded package cache:
chroot "$TGT_ROOT" "$EATMYDATA" apt-get clean
