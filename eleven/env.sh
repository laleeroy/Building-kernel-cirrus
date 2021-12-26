#!/usr/bin/env bash

mkdir -p ~/.config/rclone
echo "$rcloneconfig" > ~/.config/rclone/rclone.conf
mkdir -p /tmp/ccache
rclone copy anggitjav:ccache/rom/ccache.tar.gz /tmp -P
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz
rclone copy anggitjav:Spark rom.tar.gz /tmp -P
time tar xf rom.tar.gz
rm -rf rom.tar.gz
cat /etc/os*
env
nproc
