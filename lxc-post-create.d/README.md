# lxc-post-create.d

This directory contains scripts that are intended to be run (sourced) by the main
`lxc-create-base.sh` script *AFTER* the LXC container has been created.

They are supposed to be symlinked from the distribution/release specific configuration,
i.e. [`distributions/debian/8_jessie/lxc-post-create.d/`](distributions/debian/8_jessie/lxc-post-create.d/).
