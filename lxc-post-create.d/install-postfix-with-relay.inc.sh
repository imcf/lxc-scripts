#!/bin/bash

# make bash complain if we're accessing any unset variable:
set -o nounset

POSTFIX_SETTINGS="settings/postfix-relay.inc.sh"
if ! [ -r "$POSTFIX_SETTINGS" ] ; then
    echo "ERROR: unable to read postfix settings file: $POSTFIX_SETTINGS"
    exit 5
fi
. $POSTFIX_SETTINGS

# prepare installation of packages requiring configuration:
chroot "$TGT_ROOT" debconf-set-selections <<< EOF
postfix postfix/main_mailer_type string 'Satellite system'
postfix postfix/mailname string $VM_HOSTNAME
postfix postfix/relayhost string $POSTFIX_RELAYHOST
postfix postfix/root_address $POSTFIX_ROOTADDRESS
EOF


chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install postfix

# revert to bash's default of not complaining about unset variables:
set +o nounset
