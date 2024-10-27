#!/bin/bash

if [ ! $ARTIFACTS_DIR ];then
    ARTIFACTS_DIR=$HOME/artifacts
fi

if [ ! $ANDROID_NDK ];then
    ANDROID_NDK=~/soft/android-ndk-r21e
fi

TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=android-arm64
mkdir -p $BUILD_DIR
cd $BUILD_DIR

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/benchmark/1.7.0/android-arm64 \
    -DBENCHMARK_ENABLE_TESTING=OFF \
    -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .
cmake --install .

cd ..
