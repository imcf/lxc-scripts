#!/bin/bash

# ensure hostname resolution is working
echo "127.0.1.1 $VM_HOSTNAME.local $VM_HOSTNAME" >> $TGT_ROOT/etc/hosts
