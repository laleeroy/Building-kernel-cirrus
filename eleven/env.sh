#!/usr/bin/env bash

mkdir -p ~/.config/rclone
echo "$RCLONECONFIG" > ~/.config/rclone/rclone.conf
mkdir -p /tmp/ccache
cd /tmp
rclone copy NFS:ccache/kernel/ccache.tar.gz /tmp -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat /etc/os*
env
nproc
