#!/bin/bash

# prepare installation of packages requiring configuration:
echo "
mysql-server mysql-server/root_password password $MYSQL_ROOTPW
mysql-server mysql-server/root_password_again password $MYSQL_ROOTPW
" | chroot "$TGT_ROOT" debconf-set-selections


chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install mysql-server
