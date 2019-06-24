#!/bin/bash

# install eatmydata to speed up I/O challenging operations:
chroot $TGT_ROOT apt-get -y install eatmydata

# set / update the EATMYDATA variable accordingly:
EATMYDATA="eatmydata"
