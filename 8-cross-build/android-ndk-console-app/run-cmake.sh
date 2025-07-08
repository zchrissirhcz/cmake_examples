#!/bin/bash
NDK=~/soft/android-ndk/r21e
cmake \
    -S . \
    -B build \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=21

cmake --build build

adb push build/hello /data/local/tmp/hello
adb shell "cd /data/local/tmp; chmod +x ./hello; ./hello"
