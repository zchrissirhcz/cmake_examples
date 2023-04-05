#!/bin/bash

ANDROID_NDK=~/soft/android-ndk-r21e
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=android-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake ../.. \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DHPCC_USE_AARCH64=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=~/artifacts/ppl.cv/0.6.2/android-arm64 \
    -DPPLCV_INSTALL=ON \
    -DPPLCV_BUILD_TESTS=OFF \
    -DPPLCV_BUILD_BENCHMARK=OFF \
    -DPPLCV_HOLD_DEPS=ON \
    -DPPLCV_DEPS_USE_GITEE=ON

#ninja
#cmake --build . --verbose
cmake --build . -j

cd ..
