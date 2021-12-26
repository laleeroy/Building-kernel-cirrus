#!/usr/bin/env bash

mkdir -p ~/.config/rclone
echo "$RCLONECONFIG" > ~/.config/rclone/rclone.conf
cd $OLDPWD
rclone copy NFS:ccache/kernel/ccache.tar.gz $OLDPWD -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
cat /etc/os*
env
nproc
