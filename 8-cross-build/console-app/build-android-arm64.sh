#!/bin/bash

ANDROID_NDK=~/soft/android-ndk/r21e
TOOLCHAIN=$ANDROID_NDK/build/cmake/android.toolchain.cmake

BUILD_DIR=build-android-arm64

cmake \
    -S . \
    -B $BUILD_DIR \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DANDROID_LD=lld \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-24 \
    -DCMAKE_BUILD_TYPE=Release

cmake --build $BUILD_DIR
