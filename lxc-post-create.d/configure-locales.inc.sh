#!/bin/bash

# configure default locale
sed -i "s,^# $TGT_LOCALE,$TGT_LOCALE," "$TGT_ROOT"/etc/locale.gen
chroot "$TGT_ROOT" "$EATMYDATA" locale-gen "$TGT_LOCALE"
chroot "$TGT_ROOT" "$EATMYDATA" update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
