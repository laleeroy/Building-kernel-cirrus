#!/usr/bin/env bash

echo "Downloading few Dependecies . . ."
# Kernel Sources
git clone https://github.com/NFS-projects/kernel_xiaomi_rosy -b eleven $pwd/$DEVICE_CODENAME
# Toolchain
git clone --depth=1 https://github.com/NFS-projects/gcc-arm -b 11.x $pwd/GCC32
git clone --depth=1 https://github.com/NFS-projects/gcc-arm64 -b 11.x $pwd/GCC64
git clone --depth=1 https://github.com/AnGgIt88/Finix-Clang -b 14.x $pwd/CLANG
