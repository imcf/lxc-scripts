#!/bin/bash

SIMPLIFY="https://github.com/ehrenfeu/simplify.git"
SETUP_SCRIPT="/opt/setup-autogit-etc.sh"

chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install git cron

chroot "$TGT_ROOT" "$EATMYDATA" git clone "$SIMPLIFY" /opt/simplify

cat > "$TGT_ROOT/$SETUP_SCRIPT" << EOF
REPONAME="autogit-etc-${VM_HOSTNAME}"
mkdir -pv /var/autogit
export GIT_DIR=/var/autogit/\${REPONAME}.git
export GIT_WORK_TREE=/etc
git init
chmod go-rx "\$GIT_DIR"

cd "\$GIT_WORK_TREE"
mkdir cron.d
cp -v /opt/simplify/autogit/cronjob.autogit-etc cron.d/autogit-etc
cp -v /opt/simplify/autogit/gitignore.etc .gitignore
git config --global user.name "root (${VM_HOSTNAME})"
git config --global user.email "root@${VM_HOSTNAME}"

git add .
git commit -a -m "Initial import of /etc on host '${VM_HOSTNAME}'.

Automatically issued by lxc-scripts."
EOF

# DEBUGGING (disabled by default)
# echo "--------------------------------------------------------"
# cat "$TGT_ROOT/$SETUP_SCRIPT"
# echo "--------------------------------------------------------"

chroot "$TGT_ROOT" "$EATMYDATA" bash $SETUP_SCRIPT
