#!/bin/bash

# set required common environment variables used throughout lxc-scripts

export LANG=C
export LC_ALL=C

HOST_DIST=$(lsb_release -i -s)
HOST_REL=$(lsb_release -r -s)
HOST_REL_NAME=$(lsb_release -c -s)

BASEDIR="${LXCPATH:-/scratch/containers}"
TGT_ROOT="$BASEDIR/$VM_HOSTNAME/rootfs"
TGT_LOCALE="en_US.UTF-8"

BRIDGE_DEV="${LXC_BRIDGE_DEV:-lxcbr0}"
BRIDGE_IP=$(ip -o -f inet addr show "$BRIDGE_DEV" | sed -n 's,.*inet \([0-9\.]*\)/.*,\1,p')
