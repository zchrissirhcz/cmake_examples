#!/bin/bash

ANDROID_NDK=~/soft/android-ndk-r21e
#ANDROID_NDK=/Users/chris/soft/android-ndk-r21
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

echo "ANDROID_NDK is $ANDROID_NDK"
echo "TOOLCHAIN is: $TOOLCHAIN"

BUILD_DIR=android-arm32
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="armeabi-v7a" \
    -DANDROID_ARM_NEON=ON \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .

cd ..

###########################
# 字段说明
#--------------------------
# ANDROID_LD=lld
# 从NDK20开始可以使用lld作为链接器，替代默认的ld
#
#--------------------------
# ANDROID_PLATFORM=android-21
# ANDROID_PLATFORM
# 这个值是指定应用或库所支持的最低 API 级别。此值对应于应用的 minSdkVersion
# 不使用AndroidStudio的gradle构建，而是手动用cmake编库或者可执行程序时，应当指定这个值
# 通常是指定为16或更高的值，因为从16开始，android.toolchain.cmake中默认开启ANDROID_PIE
# 否则，需要自行在CMake脚本中设定fPIE，一来很傻，二来无端多出一对warning
# P.S. 这个字段有个别名，叫做ANDROID_NATIVE_API_LEVEL
# P.P.S 当设定>=16的level值后，fPIC也会被自动设定。
#
#--------------------------