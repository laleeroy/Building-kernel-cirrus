#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth 1 https://github.com/nhAsif/kernel_xiaomi_rosy.git -b tortoise297 $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
git clone --depth 1 https://gitlab.com/AnGgIt86/nfs-clang.git -b main $CIRRUS_WORKING_DIR/CLANG
git clone --depth 1 https://github.com/Pulkit077/gcc-arm -b gcc-master $CIRRUS_WORKING_DIR/GCC32
git clone --depth 1 https://github.com/Pulkit077/gcc-arm64 -b gcc-master $CIRRUS_WORKING_DIR/GCC64
