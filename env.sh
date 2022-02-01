#!/usr/bin/env bash

mkdir -p ~/.config/rclone
echo "$RCLONECONFIG" > ~/.config/rclone/rclone.conf
cd $CIRRUS_WORKING_DIR
rclone copy NFS:ccache/kernel/ccache.tar.gz $CIRRUS_WORKING_DIR -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat /etc/os*
gcc --version
clang --version
env
nproc
