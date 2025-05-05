#!/bin/bash

# https://developer.android.google.cn/ndk/guides/other_build_systems?hl=zh-cn
# HOST_TAG: darwin-x86_64, linux-x86_64, windows-x86_64
# ABI: aarch64-linux-android, armv7a-linux-androideabi, x86_64-linux-android, i686-linux-android

NDK=~/soft/android-ndk/r21e
HOST_TAG=darwin-x86_64
$NDK/toolchains/llvm/prebuilt/$HOST_TAG/bin/clang++ \
    -target aarch64-linux-android21 hello.cpp \
    -o hello

adb push hello /data/local/tmp/hello
adb shell "cd /data/local/tmp; chmod +x ./hello; ./hello"

