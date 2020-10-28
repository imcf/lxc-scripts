#!/bin/bash

# make bash complain if we're accessing any unset variable:
set -o nounset

# the "settings" dir is expected to be in the distribution/suite directory:
POSTFIX_SETTINGS="$(dirname "$0")/settings/postfix-relay.inc.sh"
if ! [ -r "$POSTFIX_SETTINGS" ] ; then
    echo "ERROR: unable to read postfix settings file: $POSTFIX_SETTINGS"
    exit 5
fi
. "$POSTFIX_SETTINGS"

# prepare installation of packages requiring configuration:
chroot "$TGT_ROOT" debconf-set-selections << EOF
postfix postfix/main_mailer_type string Satellite system
postfix postfix/protocols string all
postfix postfix/mailname string $VM_HOSTNAME
postfix postfix/destinations string $VM_HOSTNAME, localhost
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


# now install the package and also install a command-line "mail" utility:
chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install postfix bsd-mailx

# the "postfix/destination" setting for debconf seems to be ignored, so we adjust the
# postfix config manually again:
sed "s/^mydestination =.*/mydestination = $VM_HOSTNAME, localhost/" \
    -i "$TGT_ROOT/etc/postfix/main.cf"

# revert to bash's default of not complaining about unset variables:
set +o nounset

# optionally (and therefore only possible after disabling the "nounset" bash option
# again) add a line to /etc/hosts:
if [ -n "$ADD_TO_ETC_HOSTS" ] ; then
    echo -e "\n$ADD_TO_ETC_HOSTS" >> "$TGT_ROOT/etc/hosts"
fi

# DEBUGGING (disabled by default)
# echo "--------------------------------------------------------"
# cat "$TGT_ROOT/etc/postfix/main.cf"
# echo "--------------------------------------------------------"
# cat "$TGT_ROOT/etc/aliases"
# echo "--------------------------------------------------------"
# cat "$TGT_ROOT/etc/hosts"
# echo "--------------------------------------------------------"
