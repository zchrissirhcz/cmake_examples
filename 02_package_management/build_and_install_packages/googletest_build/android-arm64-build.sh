#!/bin/bash

ARTIFACTS_DIR=$HOME/artifacts
ANDROID_NDK=~/soft/android-ndk-r21e
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=android-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/googletest/1.11.0/android-arm64 \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_GMOCK=OFF \
    ../..

#ninja
#cmake --build . --verbose
cmake --build . -j
cmake --install .

cd ..
