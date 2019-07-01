#!/bin/bash

MARK="*************************************************************************"
EXT_IP=$(ip -o -f inet addr show eth0 | sed -n 's,.*inet \([0-9\.]*\)/.*,\1,p')

set +x

echo -e "\\n$MARK"
echo "Installation finsihed, external IP address: ${EXT_IP}"
echo -e "\\n$MARK"