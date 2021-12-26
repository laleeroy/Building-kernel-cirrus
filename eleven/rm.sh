#!/usr/bin/env bash

cd ${KERNEL_ROOTDIR}
make -j8 O=out clean && make -j8 O=out mrproper && rm -rf $PWD/AnyKernel
cd $PWD