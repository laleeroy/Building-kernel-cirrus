#!/usr/bin/env bash

mkdir -p ~/.config/rclone
echo "$RCLONECONFIG" > ~/.config/rclone/rclone.conf
mkdir -p $PWD/ccache
cd $PWD
rclone copy NFS:ccache/kernel/ccache.tar.gz $PWD -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat /etc/os*
env
nproc
