#!/bin/bash

# prepare installation of packages requiring configuration:
echo "
postfix postfix/mailname string $VM_HOSTNAME
postfix postfix/main_mailer_type string 'Local only'
" | chroot $TGT_ROOT debconf-set-selections


chroot $TGT_ROOT $EATMYDATA apt-get -y install postfix
