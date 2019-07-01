#!/bin/bash

# clean up the script blocking dpkg from triggering daemon starts:
rm -f "$TGT_ROOT"/usr/sbin/policy-rc.d
