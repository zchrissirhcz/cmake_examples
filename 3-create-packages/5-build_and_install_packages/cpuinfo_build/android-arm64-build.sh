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
    -DCPUINFO_BUILD_UNIT_TESTS=OFF \
    -DCPUINFO_BUILD_MOCK_TESTS=OFF \
    -DCPUINFO_BUILD_BENCHMARKS=OFF \
    -DCMAKE_INSTALL_PREFIX=$ARTIFACTS_DIR/cpuinfo/master/android-arm64 \
    ../..

#ninja
#cmake --build . --verbose
cmake --build .
cmake --install .

cd ..
