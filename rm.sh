#!/usr/bin/env bash

# Main Declaration
KERNEL_ROOTDIR=$CIRRUS_WORKING_DIR/$DEVICE_CODENAME

cd ${KERNEL_ROOTDIR}
make O=out clean && make O=out mrproper && 
rm -rf $CIRRUS_WORKING_DIR/AnyKernel