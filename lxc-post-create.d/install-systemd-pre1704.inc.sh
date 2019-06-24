#!/bin/bash

# on Ubuntu host systems before 17.04 it was necesary to install sysvinit-core and
# systemd-shim (see Debian bug #766233 for details), this is not required on
# Ubuntu 17.04 any more!
chroot $TGT_ROOT $EATMYDATA apt-get -y install sysvinit-core systemd-shim
