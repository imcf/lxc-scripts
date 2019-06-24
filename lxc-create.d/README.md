# lxc-create.d

This directory contains scripts that are intended to be run (sourced) by the main
`lxc-create-base.sh` script *BEFORE* the LXC container is actually created (by issuing
the `lxc-create` call).

They are supposed to be symlinked from the distribution/release specific configuration,
i.e. [`distributions/debian/8_jessie/lxc-create.d/`](distributions/debian/8_jessie/lxc-create.d/).
