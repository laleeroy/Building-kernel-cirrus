#!/usr/bin/env bash

# Main Declaration
function env() {
export KERNEL_NAME=Finix-kernel-Experiment-GCC
KERNEL_ROOTDIR=$pwd/$DEVICE_CODENAME
DEVICE_DEFCONFIG=rosy-perf_defconfig
GCC_ROOTDIR=$pwd/GCC64
GCC_ROOTDIR32=$pwd/GCC32
GCC_VER="$("$GCC_ROOTDIR"/bin/aarch64-elf-gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
GCC_VER32="$("$GCC_ROOTDIR32"/bin/arm-eabi-gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
LLD_VER="$("$GCC_ROOTDIR"/bin/ld.lld --version | head -n 1)"
IMAGE=$pwd/$DEVICE_CODENAME/out/arch/arm64/boot/Image.gz-dtb
DATE=$(date +"%F-%S")
START=$(date +"%s")
export KBUILD_BUILD_USER=$BUILD_USER
export KBUILD_BUILD_HOST=$BUILD_HOST
export KBUILD_COMPILER_STRING="$GCC_VER"
export KBUILD_COMPILER_STRING32="$GCC_VER32  with $LLD_VER"
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
echo GCC_ROOTDIR = ${GCC_ROOTDIR}
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
export KERNEL_USE_CCACHE=1
tg_post_msg "<b>Build Kernel GCC Started..</b>"
make -j8 O=out ARCH=arm64 SUBARCH=arm64 ${DEVICE_DEFCONFIG}
make -j8 ARCH=arm64 SUBARCH=arm64 O=out \
    CROSS_COMPILE=${GCC_ROOTDIR}/bin/aarch64-elf- \
    CROSS_COMPILE_ARM32=${GCC_ROOTDIR32}/bin/arm-eabi-
   if ! [ -a "$IMAGE" ]; then
	finerr
	exit 1
   fi
	git clone --depth=1 $ANYKERNEL $pwd/AnyKernel
	cp $IMAGE $pwd/AnyKernel
}
# Push kernel to channel
function push() {
    cd $pwd/AnyKernel
    zip -r9 $KERNEL_NAME-$DEVICE_CODENAME-${DATE}.zip *
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="$KERNEL_NAME
==========================
👤 Owner: AnGgIt86
🏚️ Linux version: $KERNEL_VERSION
🌿 Branch: $BRANCH
🎁 Top commit: $LATEST_COMMIT
👩‍💻 Commit author: $COMMIT_BY
🐧 UTS version: $UTS_VERSION
💡 Compiler: $TOOLCHAIN_VERSION
==========================
Compile took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
}
# Fin Error
function finerr() {
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
        -d chat_id="$TG_CHAT_ID" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="================================%0A<code>Building Kernel Gagal,Jiancoeg..</code>%0A================================" \
    curl -s -X POST "$BOT_MSG_URL2/sendSticker" \
        -d sticker="CAACAgIAAx0CXjGT1gACDRRhYsUKSwZJQFzmR6eKz2aP30iKqQACPgADr8ZRGiaKo_SrpcJQIQQ" \
        -d chat_id="$TG_CHAT_ID"
    exit 1
}

function info() {
cd $KERNEL_ROOTDIR
KERNEL_VERSION=$(cat $KERNEL_ROOTDIR/out/.config | grep Linux/arm64 | cut -d " " -f3)
UTS_VERSION=$(cat $KERNEL_ROOTDIR/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TOOLCHAIN_VERSION=$(cat $KERNEL_ROOTDIR/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
TRIGGER_SHA="$(git rev-parse HEAD)"
LATEST_COMMIT="$(git log --pretty=format:'%s' -1)"
COMMIT_BY="$(git log --pretty=format:'by %an' -1)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

}
env
check
compile
END=$(date +"%s")
DIFF=$(($END - $START))
info
push
