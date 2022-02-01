#!/usr/bin/env bash

mkdir -p ~/.config/rclone
echo "$RCLONECONFIG" > ~/.config/rclone/rclone.conf
cd $pwd
rclone copy NFS:ccache/kernel/ccache.tar.gz $pwd -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat /etc/os*
gcc --version
clang --version
env
nproc
