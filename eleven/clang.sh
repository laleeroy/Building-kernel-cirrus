#!/usr/bin/env bash

# Main Declaration
function env() {
export KERNEL_NAME=Finix-カーネル-バラ色-CLANG
KERNEL_ROOTDIR=$PWD/$DEVICE_CODENAME
DEVICE_DEFCONFIG=rosy-clang_defconfig
CLANG_ROOTDIR=$PWD/CLANG
CLANG_VER="$("$CLANG_ROOTDIR"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
LLD_VER="$("$CLANG_ROOTDIR"/bin/ld.lld --version | head -n 1)"
IMAGE=$PWD/$DEVICE_CODENAME/out/arch/arm64/boot/Image.gz-dtb
DATE=$(date +"%F-%S")
START=$(date +"%s")
export KBUILD_BUILD_USER=$BUILD_USER
export KBUILD_BUILD_HOST=$BUILD_HOST
export KBUILD_COMPILER_STRING="$CLANG_VER with $LLD_VER"
export BOT_MSG_URL="https://api.telegram.org/bot$TG_TOKEN/sendMessage"
export BOT_MSG_URL2="https://api.telegram.org/bot$TG_TOKEN"
}
# Checking environtment
# Warning !! Dont Change anything there without known reason.
function check() {
echo ================================================
echo "              _  __  ____  ____               "
echo "             / |/ / / __/ / __/               "
echo "      __    /    / / _/  _\ \    __           "
echo "     /_/   /_/|_/ /_/   /___/   /_/           "
echo "    ___  ___  ____     _________________      "
echo "   / _ \/ _ \/ __ \__ / / __/ ___/_  __/      "
echo "  / ___/ , _/ /_/ / // / _// /__  / /         "
echo " /_/  /_/|_|\____/\___/___/\___/ /_/          "
echo ================================================
echo BUILDER NAME = ${KBUILD_BUILD_USER}
echo BUILDER HOSTNAME = ${KBUILD_BUILD_HOST}
echo DEVICE_DEFCONFIG = ${DEVICE_DEFCONFIG}
echo TOOLCHAIN_VERSION = ${KBUILD_COMPILER_STRING}
echo CLANG_ROOTDIR = ${CLANG_ROOTDIR}
echo KERNEL_ROOTDIR = ${KERNEL_ROOTDIR}
echo ================================================
}
tg_post_msg() {
  curl -s -X POST "$BOT_MSG_URL" -d chat_id="$TG_CHAT_ID" \
  -d "disable_web_page_preview=true" \
  -d "parse_mode=html" \
  -d text="$1"
}
# Compile
compile(){
cd ${KERNEL_ROOTDIR}
make kernelversion
export VERSION=$(make kernelversion)
export KERNEL_USE_CCACHE=1
tg_post_msg "<b>Buiild Kernel Clang started..</b>"
make -j8 O=out ARCH=arm64 SUBARCH=arm64 ${DEVICE_DEFCONFIG}
make -j8 ARCH=arm64 SUBARCH=arm64 O=out \
    CC=${CLANG_ROOTDIR}/bin/clang \
    LLVM_AR=${CLANG_ROOTDIR}/bin/llvm-ar \
    LLVM_DIS=${CLANG_ROOTDIR}/bin/llvm-dis \
    NM=${CLANG_ROOTDIR}/bin/llvm-nm \
    OBJCOPY=${CLANG_ROOTDIR}/bin/llvm-objcopy \
    OBJDUMP=${CLANG_ROOTDIR}/bin/llvm-objdump \
    STRIP=${CLANG_ROOTDIR}/bin/llvm-strip \
    CROSS_COMPILE=${CLANG_ROOTDIR}/bin/aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=${CLANG_ROOTDIR}/bin/arm-linux-gnueabi-
   if ! [ -a "$IMAGE" ]; then
	finerr
	exit 1
   fi
	git clone --depth=1 $ANYKERNEL $PWD/AnyKernel
	cp $IMAGE $PWD/AnyKernel
}
# Push kernel to channel
function push() {
    cd $PWD/AnyKernel
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="<b>$KERNEL_NAME</b>
        👤 <b>Owner:</b> <code>AnGgIt86</code>
        🏚️ <b>Linux version:</b> <code>$VERSION</code>
        💡 <b>Compiler:</b> <code>$TOOLCHAIN_VERSION</code>
        🎁 <b>Top commit:</b> <code>xxxx</code>
        👩‍💻 <b>Commit author:</b> <code>xxxx</code>
        🐧 <b>UTS version:</b> <code>$(cat $KERNEL_ROOTDIR/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)</code>
        Compile took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
}
# Fin Error
function finerr() {
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
        -d chat_id="$TG_CHAT_ID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="Build throw an error(s)" \
    curl -s -X POST "$BOT_MSG_URL2/sendSticker" \
        -d sticker="CAACAgIAAx0CXjGT1gACDRRhYsUKSwZJQFzmR6eKz2aP30iKqQACPgADr8ZRGiaKo_SrpcJQIQQ" \
        -d chat_id="$TG_CHAT_ID"
    exit 1
}
# Zipping
function zipping() {
    cd $PWD/AnyKernel
    zip -r9 $KERNEL_NAME-$DEVICE_CODENAME-${DATE}.zip *
    cd $PWD
}
env
check
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
push
