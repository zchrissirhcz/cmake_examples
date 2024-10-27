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
    -DANDROID_ABI="armeabi-v7a" \
    -DANDROID_ARM_NEON=ON \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=~/artifacts/ncnn/20220701/android-arm32 \
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