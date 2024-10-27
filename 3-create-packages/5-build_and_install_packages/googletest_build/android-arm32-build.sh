#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
ANDROID_NDK=~/soft/android-ndk-r21e
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=android-arm32
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/googletest/1.11.0/android-arm32 \
    -DANDROID_LD=lld \
    -DANDROID_ABI="armeabi-v7a" \
    -DANDROID_ARM_NEON=ON \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_GMOCK=OFF \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .
cmake --install .

cd ..
