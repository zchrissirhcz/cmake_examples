#!/bin/bash

ANDROID_NDK=~/soft/android-ndk-r21e
#ANDROID_NDK=/Users/chris/soft/android-ndk-r21
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

echo "ANDROID_NDK is $ANDROID_NDK"
echo "TOOLCHAIN is: $TOOLCHAIN"

BUILD_DIR=android-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-27 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=~/artifacts/ncnn/20220420/arm64-v8a \
    -DNCNN_VULKAN=OFF \
    -DNCNN_BENCHMARK=OFF \
    -DNCNN_TESTS=OFF \
    -DNCNN_EXAMPLES=OFF \
    -DNCNN_OPENMP=ON \
    -DNCNN_TOOLS=OFF \
    -DNCNN_DISABLE_RTTI=OFF \
    -DNCNN_DISABLE_EXCEPTION=OFF \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .
cmake --install .
cd ..
