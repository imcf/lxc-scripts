#!/bin/bash

set -e

BASEDIR=$(dirname $0)
cd $BASEDIR

DEFAULTS="defaults_finalize.inc.sh"
if [ -f "$DEFAULTS" ] ; then
	source "$DEFAULTS"
fi

for SCRIPT in finalize_setup__*.sh ; do
	# make sure to return to the base dir every time, no matter what the
	# sourced script has been doing inbetween:
	cd $BASEDIR
	echo "-----------------------------------------------"
	echo "[$SCRIPT]"
	echo "-----------------------------------------------"
	set -x
	source $SCRIPT
	set +x
	echo -e "\n"
done