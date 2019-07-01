#!/bin/bash

# exit immediately on any error
set -e

usage_exit() {
    echo
    echo "Usage:"
    echo
    echo "    $0 container_name distribution suite"
    echo
    echo "    e.g.: $0 mysql_deb8 debian 8_jessie"
    echo
    exit "$1"
}

if [ -z "$1" ] ; then
    echo "ERROR: No name given for container!"
    usage_exit 1
fi
VM_HOSTNAME=$1

if [ -z "$2" ] ; then
    echo "ERROR: No distribution given!"
    usage_exit 2
fi
DISTRIBUTION=$2

if [ -z "$3" ] ; then
    echo "ERROR: No suite for distribution '$DISTRIBUTION' given!"
    usage_exit 2
fi
SUITE=$3

if [ "$4" == "--dry-run" ] ; then
    export DRY_RUN="true"
fi


cd "$(dirname "$0")"
SETUP_SCRIPTS="distributions/$DISTRIBUTION/$SUITE"
if ! [ -d "$SETUP_SCRIPTS" ] ; then
    echo "ERROR: can't find directory [$SETUP_SCRIPTS]!"
    usage_exit 3
fi

AUTH_KEYS="${AUTH_KEYS:-$(readlink settings/authorized_keys)}"
if ! [ -r "$AUTH_KEYS" ] ; then
    echo "ERROR: can't find or read authorized keys file: $AUTH_KEYS"
    usage_exit 4
fi

LOCALPKGS="$(readlink settings/localpkgs)/$DISTRIBUTION/$SUITE"
if [ -n "$LOCALPKGS" ] ; then
    echo LOCALPKGS="$LOCALPKGS"
    export LOCALPKGS
else
    echo "===================================================================="
    echo "WARNING: no 'settings/localpkgs' found, network connection required!"
    echo "===================================================================="
fi

LXCPATH="$(readlink settings/lxcpath)"
if [ -n "$LXCPATH" ] ; then
    echo LXCPATH="$LXCPATH"
    export LXCPATH
else
    echo "WARNING: no 'settings/lxcpath' found, using LXC default!"
fi


RUN_SCRIPT="$SETUP_SCRIPTS/lxc-create-base.sh"
echo -e "----------------------------------\\nLaunching [$RUN_SCRIPT]"
bash "$RUN_SCRIPT" "$VM_HOSTNAME" "$AUTH_KEYS"
echo -e "----------------------------------\\nFinished [$RUN_SCRIPT]"
echo "----------------------------------"
echo
echo "Use the following commands to start it and/or check its status:"
echo "  # lxc-start --lxcpath=$LXCPATH --name=$VM_HOSTNAME -d"
echo "  # lxc-attach --lxcpath=$LXCPATH --name=$VM_HOSTNAME"
echo "  # lxc-ls --lxcpath=$LXCPATH --fancy"
echo "  # IPV4=\$(lxc-ls --lxcpath=$LXCPATH --filter=$VM_HOSTNAME --fancy-format=IPV4 --fancy | tail -n 1)"
echo "  # ssh -i ${AUTH_KEYS/.pub/}  root@\$IPV4"
