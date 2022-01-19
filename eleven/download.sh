#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth=1 https://github.com/baunilla/android_kernel_xiaomi_rosy -b lineage-19.0 $pwd/$DEVICE_CODENAME
# Toolchain
git clone --depth=1 https://github.com/mvaisakh/gcc-arm $pwd/GCC32
git clone --depth=1 https://github.com/mvaisakh/gcc-arm64 $pwd/GCC64
git clone --depth=1 https://github.com/kdrag0n/proton-clang -b master $pwd/CLANG
