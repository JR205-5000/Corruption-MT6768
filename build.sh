#!/bin/bash

function compile() 
{
rm -rf AnyKernel
source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=Axioo
export KBUILD_BUILD_USER="KazuHikari"
git clone --depth=1 https://gitlab.com/Panchajanya1999/azure-clang clang

[ -d "out" ] && rm -rf out || mkdir -p out

make O=out ARCH=arm64 lancelot_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j4                O=out \
			ARCH=$ARCH \
			CC="clang" \
			CROSS_COMPILE=aarch64-linux-gnu- \
			CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
            LLVM=1 \
			LD=ld.lld \
			AR=llvm-ar \
			NM=llvm-nm \
			OBJCOPY=llvm-objcopy \
			OBJDUMP=llvm-objdump \
			STRIP=llvm-strip \
			CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
git clone --depth=1 https://github.com/JR205-5000/AnyKernel3-1 -b lancelot AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Succubus-Kernel-Lamcot-JR205-4.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet Succubus-Kernel-Lamcot-JR205-1.zip
}

compile
zupload
