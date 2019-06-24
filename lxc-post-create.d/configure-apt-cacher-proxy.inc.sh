#!/bin/bash

# configure apt to use the local apt-cacher-ng:
echo "Acquire::http { Proxy \"http://$BRIDGE_IP:3142\"; };" > $TGT_ROOT/etc/apt/apt.conf.d/01proxy
