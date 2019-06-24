#!/bin/bash

export LANG=C
export LC_ALL=C

HOST_DIST=$(lsb_release -i -s)
HOST_REL=$(lsb_release -r -s)

BASEDIR="${LXCPATH:-/scratch/containers}"
TGT_ROOT="$BASEDIR/$VM_HOSTNAME/rootfs"
TGT_LOCALE="en_US.UTF-8"

BRIDGE_IP=$(ip -o -f inet addr show lxcbr0 | sed -n 's,.*inet \([0-9\.]*\)/.*,\1,p')
