#!/bin/bash

# parse the command line parameters and make sure to have all required options set

if [ -z "$1" ] ; then
    echo "ERROR: No name given for container!"
    usage_exit 1
fi
VM_HOSTNAME=$1

if [ -z "$2" ] ; then
    echo "ERROR: No file for 'authorized_keys' given!"
    usage_exit 2
fi
AUTH_KEYS=$2
