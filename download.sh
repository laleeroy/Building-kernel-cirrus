#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone --depth=1 https://github.com/NFS86/kernel_xiaomi_rosy -b twelve $pwd/$DEVICE_CODENAME
# Toolchain
git clone --depth=1 https://github.com/mvaisakh/gcc-arm -b gcc-master $pwd/GCC32
git clone --depth=1 https://github.com/mvaisakh/gcc-arm64 -b gcc-master $pwd/GCC64
git clone --depth=1 https://github.com/kdrag0n/proton-clang -b master $pwd/CLANG