#!/bin/bash

chroot "$TGT_ROOT" "$EATMYDATA" apt-get -y install \
    sudo \
    vim \
    bash-completion \
    iputils-ping \
    cron \
    rsyslog
