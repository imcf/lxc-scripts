#!/bin/bash

# prevent sshd's stupid behaviour of overriding the locale environment:
sed -i 's,^AcceptEnv,#AcceptEnv,' "$TGT_ROOT"/etc/ssh/sshd_config

if [ -z "$AUTH_KEYS" ]; then
    echo "*** WARNING ***: var '\$AUTH_KEYS' not set, skipping authorized_keys setup!"
else
    # configure ssh-access for the root account
    mkdir -pv "$TGT_ROOT"/root/.ssh
    cp -v "$AUTH_KEYS" "$TGT_ROOT"/root/.ssh/authorized_keys
fi
