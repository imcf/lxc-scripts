#!/bin/bash

# configure timezone, use the same as the host system:

cp -a /etc/localtime "$TGT_ROOT"/etc/localtime
chroot "$TGT_ROOT" "$EATMYDATA" dpkg-reconfigure -f noninteractive tzdata
