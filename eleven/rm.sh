#!/usr/bin/env bash

# Main Declaration
KERNEL_ROOTDIR=$OLDPWD/$DEVICE_CODENAME

cd ${KERNEL_ROOTDIR}
make O=out clean && make O=out mrproper && rm -rf AnyKernel