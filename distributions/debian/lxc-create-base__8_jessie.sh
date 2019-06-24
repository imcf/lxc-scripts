#!/bin/bash

# exit immediately on any error
set -e

usage_exit() {
    echo
    echo "Usage:"
    echo
    echo "    $0 container_name /path/to/ssh_pubkey_or_authorized_keys"
    echo
    exit $1
}

SCRIPTS_DIR="$(dirname $0)/lxc-create.d"
echo -e "\n>>>>>> Processing scripts in [${SCRIPTS_DIR}/]..."
for INC in ${SCRIPTS_DIR}/[0-9][0-9]_*\.inc\.sh ; do
    echo -e "\n>>> Sourcing [$INC]"
    source $INC
done
echo -e "\n>>>>>> Finished processing scripts in [${SCRIPTS_DIR}/].\n"

#############################################################
# LXC base setup
#############################################################

echo
echo ------------------------ settings ------------------------
echo SUITE=$SUITE
echo VM_HOSTNAME=$VM_HOSTNAME
echo TGT_ROOT=$TGT_ROOT
echo TGT_LOCALE=$TGT_LOCALE
echo BRIDGE_IP=$BRIDGE_IP
echo -------------------- lxc-create command ------------------
echo lxc-create --lxcpath=$BASEDIR --name=$VM_HOSTNAME -t $DISTRIBUTION -- --release=$SUITE
echo
if [ -n "$DRY_RUN" ] ; then
    echo ">>> dry-run requested, stopping here! <<<"
    exit 0
fi
lxc-create --lxcpath=$BASEDIR --name=$VM_HOSTNAME -t $DISTRIBUTION -- --release=$SUITE

# set EATMYDATA to empty, will be overridden in one of the sourced scripts if enabled:
EATMYDATA=""

# read distribution-specific default settings:
source $(dirname $0)/debian_defaults.inc.sh

# run (source) post-create scripts:
SCRIPTS_DIR="$(dirname $0)/lxc-post-create.d"
echo -e "\n>>>>>> Processing post-create scripts in [${SCRIPTS_DIR}/]..."
for INC in ${SCRIPTS_DIR}/[0-9][0-9]_*\.inc\.sh ; do
    echo -e "\n>>> Sourcing [$INC]"
    source $INC
done
echo -e "\n>>>>>> Finished processing post-create scripts in [${SCRIPTS_DIR}/].\n"


#############################################################
# prepare finalization scripts to be run after startup
#############################################################
FINALIZE_D="$(dirname $0)/finalize.d"
if [ -d "$FINALIZE_D" ] ; then
    SETUP_SCRIPTS=$TGT_ROOT/root/lxc-finalize-setup
    mkdir -v $SETUP_SCRIPTS
    cp -vL $FINALIZE_D/* $SETUP_SCRIPTS/
    echo "Scripts to finalize the LXC container setup have been placed here:"
    echo "  > $SETUP_SCRIPTS"
    echo
    echo "Log in as user 'root', then just launch:"
    echo
    echo "  # bash $SETUP_SCRIPTS/do_finalize_setup.sh"
    echo
fi


#############################################################
# finish
#############################################################
# clean up downloaded package cache:
chroot $TGT_ROOT eatmydata apt-get clean
