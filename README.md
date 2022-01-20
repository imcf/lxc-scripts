# LXC Helper Scripts

Scripts and stuff to automatically create [LXC containers][lxc] in various flavours.

## Design

The repository is a collection of modular shell script snippets ("*scriptlets*"), each
doing just *one* small task. They can be combined to form a *configuration* for a
container using the `distributions/` directory with the corresponding sub-directories by
using symbolic links to point to the scriptlets that should be run during setup. A
minimal setup could look like this:

```text
distributions/
└── debian
    ├── 8_jessie
    │   ├── debian_defaults.inc.sh -> ../debian_defaults.inc.sh
    │   ├── lxc-create-base.sh -> ../lxc-create-base__8_jessie.sh
    │   ├── lxc-create.d
    │   │   ├── 00_parse-cmdline.inc.sh -> ../../../../lxc-create.d/parse-cmdline.inc.sh
    │   │   ├── 01_set-common-vars.inc.sh -> ../../../../lxc-create.d/set-common-vars.inc.sh
    │   │   ├── 02_check-host-ubu1810.inc.sh -> ../../../../lxc-create.d/check-host-ubu1904.inc.sh
    │   │   └── 03_set-vars-deb8.inc.sh -> ../../../../lxc-create.d/set-vars-deb8.inc.sh
    │   └── lxc-post-create.d
    │       ├── 00_configure-sources-list.inc.sh -> ../../../../lxc-post-create.d/configure-sources-list.inc.sh
    │       ├── 01_configure-apt-cacher-proxy.inc.sh -> ../../../../lxc-post-create.d/configure-apt-cacher-proxy.inc.sh
    │       ├── 02_prepare-apt.inc.sh -> ../../../../lxc-post-create.d/prepare-apt.inc.sh
    │       ├── 03_install-eatmydata.inc.sh -> ../../../../lxc-post-create.d/install-eatmydata.inc.sh
    │       ├── 04_configure-etc-hosts.inc.sh -> ../../../../lxc-post-create.d/configure-etc-hosts.inc.sh
    │       ├── 05_configure-ssh.inc.sh -> ../../../../lxc-post-create.d/configure-ssh.inc.sh
    │       ├── 06_configure-locales.inc.sh -> ../../../../lxc-post-create.d/configure-locales.inc.sh
    │       ├── 07_configure-service-startup-disable.inc.sh -> ../../../../lxc-post-create.d/configure-service-startup-disable.inc.sh
    │       ├── 08_install-default-packages.inc.sh -> ../../../../lxc-post-create.d/install-default-packages.inc.sh
    │       └── 99_configure-service-startup-enable.inc.sh -> ../../../../lxc-post-create.d/configure-service-startup-enable.inc.sh
    ├── debian_defaults.inc.sh
    └── lxc-create-base__8_jessie.sh
```

## Concept Of Operation

A new container can be created by running the top-level
[new-lxc-container.sh](new-lxc-container.sh) script that will verify all necessary
options are set, read the settings (see below) and eventually launch the corresponding
(distribution-specific, maybe even release-specific) setup script, e.g.
[lxc-create-base__8_jessie.sh](distributions/debian/lxc-create-base__8_jessie.sh).

While in general the specific setup script is free to do whatever is required, the
supplied scripts work essentially in three stages:

1. First, all scriptlets in the corresponding `lxc-create.d/` directory are being
   processed by sourcing them in alphanumeric order.
1. Once this has completed, the actual `lxc-create` command is issued that will take the
   required action(s) to setup a container with the desired distribution and release.
1. After the container has been created, the scriptlets in `lxc-post-create.d` will be
   sourced in the same fashion as described above. These scriptlets can be used to
   install additional packages into the container or to configure specific settings.
   Please note that they are run from the *host* system, i.e. **not** within the running
   container (no container is actually started during the execution of the scripts). See
   the provided scripts for examples on how to affect the container.

In an optional step, finalization scripts and / or data can be copied into the
container to be executed / used from within the running container.

## Preparations / Prerequisites

It is strongly recommended to set up [apt-cacher-ng][acng] on the LXC host to speed up
(subsequent) installations of containers. If done, make sure to use the
[configure-apt-cacher-proxy.inc.sh](lxc-post-create.d/configure-apt-cacher-proxy.inc.sh)
scriptlet during container setup.

### Other Requirements

Obviously, LXC needs to be installed on your system. As these scripts expect to operate
on Debian or Ubuntu, this can be achieved via

```bash
apt install -y \
    lxc \
    lxc-templates \
    debootstrap
```

## Settings

A few common settings are configured by placing symlinks in the `settings/` directory.

### SSH Keys

Create a symlink to an ssh public key or `authorized_keys` file:

```bash
cd settings/
ln -s $HOME/.ssh/id_rsa.pub authorized_keys
cd -
```

This can also be done on a configuration-specific level (having priority over the
symlink described above):

```bash
cd distributions/debian/8_jessie_with_mysql/settings
ln -s $HOME/.ssh/id_rsa-specialkey.pub authorized_keys
cd -
```

### LXC Path

Instead of setting the **`LXCPATH`** environment variable (which is of course supported
as well), you can create a symlink called `lxcpath` like so:

```bash
cd settings/
ln -s /scratch/containers lxcpath
cd -
```

### Local Package Cache

In addition to using Apt-Cacher-NG it is also supported to use a local package cache
that will be copied into the container by the [prepare-apt.inc.sh](lxc-post-create.d/prepare-apt.inc.sh)
scriptlet. To enable it, create a symlink called `localpkgs` pointing to a location
containing a subdirectory **`lists`** with APT list files (like `/var/lib/apt/lists/`)
and a subdirectory **`archives`** containing (some of) the corresponding `.deb` files
(like `/var/cache/apt/archives/`).

#### Preparations

Building up the cache can be done by setting up an LXC container without cache (the
scriptlet mentioned above will automatically do this, but make sure to *disable* the
[apt-get-clean.inc.sh](lxc-post-create.d/apt-get-clean.inc.sh) scriptlet when creating
the container) and then copy the relevant files to the desired cache location on the
host system, for example:

```bash
sudo -s -H  # only required for tab-completing into the container filesystem
CACHE_BASE=/scratch/cache/localpkgs/debian/8_jessie
CONTAINER_FS=/scratch/containers/vamp_deb8_mysql/rootfs

mkdir -pv $CACHE_BASE/lists
mkdir -pv $CACHE_BASE/archives
cp -u $CONTAINER_FS/var/cache/apt/archives/*.deb $CACHE_BASE/archives/
cp -u $CONTAINER_FS/var/lib/apt/lists/* $CACHE_BASE/lists/
rm $CACHE_BASE/lists/lock
```

Updating the package cache can also be done through a running container of the relevant
distribution / release combination. Just copy the existing archives there, update the
APT lists and ask APT to remove outdated packages from the cache. Then discard the
previous archives on the host system and copy (move) back the ones from the container:

In the LXC container:

```bash
apt-get update
apt-get autoclean
```

On the host system:

```bash
sudo -s -H  # only required for tab-completing into the container filesystem
CACHE_BASE=/scratch/cache/localpkgs/debian/8_jessie
CONTAINER_FS=/scratch/containers/test_deb8_vanilla_01/rootfs
rm $CACHE_BASE/archives/*.deb
cp $CONTAINER_FS/var/cache/apt/archives/*.deb $CACHE_BASE/archives/
```

The APT list files can be updated using the last two lines of the commands describing
how to build up the cache initially.

#### Using The Package Cache

This can either be done in the common `settings/` directory or per configuration (the
latter overriding the former in case both are being present).

##### Common Cache Settings

Common setting for all configurations:

```bash
cd settings
ln -s /scratch/cache/localpkgs
cd -

# the directory layout is expected to be this:
tree -L 3 -d settings/localpkgs
# settings/localpkgs
# ├── centos
# │   └── x86_64
# │       ├── 6
# │       └── 7
# └── debian
#     └── 8_jessie
#         ├── archives
#         └── lists
```

##### Configuration-Specific Cache Settings

Using a configuration-specific package cache, the symlink is expected to point to the
directory containing the `archives` and `lists` directories directly (in case of Debian
setups):

```bash
cd distributions/debian/8_jessie_with_mysql/settings
ln -s /scratch/cache/localpkgs/debian/8_jessie localpkgs
cd -
```

[lxc]: https://linuxcontainers.org/
[acng]: https://wiki.debian.org/AptCacherNg
