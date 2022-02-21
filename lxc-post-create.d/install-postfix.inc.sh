#!/bin/bash

function postfix_local_only() {
    # prepare installation of packages requiring configuration:
    echo "
    postfix postfix/mailname string $VM_HOSTNAME
    postfix postfix/main_mailer_type string 'Local only'
    " | chroot "$TGT_ROOT" debconf-set-selections

    chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install postfix
}

function postfix_with_relay() {
    . "$POSTFIX_SETTINGS"

    # prepare installation of packages requiring configuration:
    chroot "$TGT_ROOT" debconf-set-selections <<EOF
postfix postfix/main_mailer_type string Satellite system
postfix postfix/protocols string all
postfix postfix/mailname string $VM_HOSTNAME
postfix postfix/destinations string $VM_HOSTNAME, localhost
postfix postfix/relayhost string $POSTFIX_RELAYHOST
postfix postfix/root_address string $POSTFIX_ROOTADDRESS
EOF

    TGT_ETC="$TGT_ROOT/etc"

    # /etc/mailname is required, otherwise a postfix-relay will reject mails from the
    # container saying "Relay access denied" - NOTE that it doesn't have to be an FQDN,
    # even though that would somehow make more sense...
    echo "$VM_HOSTNAME" >"$TGT_ETC/mailname"

    # now install the package and also install a command-line "mail" utility:
    chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install postfix bsd-mailx

    # the "postfix/destination" setting for debconf seems to be ignored, so we adjust the
    # postfix config manually again.
    # NOTE that "mydestination" MUST include what is set in /etc/mailname, otherwise postfix
    # will ignore things like /etc/aliases (and probably other stuff)
    sed "s/^mydestination =.*/mydestination = $VM_HOSTNAME, localhost/" \
        -i "$TGT_ETC/postfix/main.cf"

    # tell postfix to actually *use* /etc/mailname
    sed "s/^#myorigin =/myorigin =/" -i "$TGT_ETC/postfix/main.cf"

    # revert to bash's default of not complaining about unset variables:
    set +o nounset

    # optionally (and therefore only possible after disabling the "nounset" bash option
    # again) add a line to /etc/hosts:
    if [ -n "$ADD_TO_ETC_HOSTS" ]; then
        echo -e "\n$ADD_TO_ETC_HOSTS" >>"$TGT_ETC/hosts"
    fi

    # DEBUGGING (disabled by default)
    # echo "--------------------------------------------------------"
    # cat "$TGT_ETC/postfix/main.cf"
    # echo "--------------------------------------------------------"
    # cat "$TGT_ETC/aliases"
    # echo "--------------------------------------------------------"
    # cat "$TGT_ETC/hosts"
    # echo "--------------------------------------------------------"
}

# make bash complain if we're accessing any unset variable:
set -o nounset

# the "settings" dir is expected to be in the distribution/suite directory:
POSTFIX_SETTINGS="$(dirname "$0")/settings/postfix-relay.inc.sh"
if [ -r "$POSTFIX_SETTINGS" ]; then
    echo "Setting up postfix USING A RELAY as defined in: $POSTFIX_SETTINGS"
    postfix_with_relay
else
    echo "Setting up postfix in LOCAL-ONLY mode."
    postfix_local_only
fi
