#!/usr/bin/env bash

cd /tmp/${KERNEL_ROOTDIR}
make O=out clean && make O=out mrproper && rm -rf AnyKernel
cd /tmp