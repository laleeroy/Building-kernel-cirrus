#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth 1 https://github.com/baunilla/android_kernel_xiaomi_rosy -b lineage-19.0 $CIRRUS_WORKING_DIR/$DEVICE_CODENAME
# Toolchain
git clone --depth 1 https://gitlab.com/AnGgIt86/nfs-clang.git -b main $CIRRUS_WORKING_DIR/CLANG
