#!/bin/bash

# make bash complain if we're accessing any unset variable:
set -o nounset

# the "settings" dir is expected to be in the distribution/suite directory:
POSTFIX_SETTINGS="$(dirname "$0")/settings/postfix-relay.inc.sh"
if ! [ -r "$POSTFIX_SETTINGS" ] ; then
    echo "ERROR: unable to read postfix settings file: $POSTFIX_SETTINGS"
    exit 5
fi
. $POSTFIX_SETTINGS

# prepare installation of packages requiring configuration:
chroot "$TGT_ROOT" debconf-set-selections << EOF
postfix postfix/main_mailer_type string 'Satellite system'
postfix postfix/mailname string $VM_HOSTNAME
postfix postfix/relayhost string $POSTFIX_RELAYHOST
postfix postfix/root_address $POSTFIX_ROOTADDRESS
EOF

# for whatever reason, the postfix debian package setup scripts will create /etc/aliases
# if it doesn't exist (which is usually the case in our stage of the installation), but
# they don't add the root recipient there - so we simply pre-create the file (which
# won't be touched by the package's scripts):
cat > "$TGT_ROOT/etc/aliases" << EOF
# See man 5 aliases for format
postmaster:    root
root: $POSTFIX_ROOTADDRESS
EOF


chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install postfix

# revert to bash's default of not complaining about unset variables:
set +o nounset
