#!/bin/bash

# add sourcing bash-completion to root's bashrc unless it's already there:
BASH_COMPLETION=". /etc/bash_completion"
BASHRC="$TGT_ROOT/root/.bashrc"
grep -qs "^$BASH_COMPLETION" "$BASHRC" || echo -e "\n$BASH_COMPLETION" >>"$BASHRC"
