#!/bin/bash
NDK=~/soft/android-ndk-r21e
HOST_TAG=darwin-x86_64
$NDK/toolchains/llvm/prebuilt/$HOST_TAG/bin/clang++ \
    -target aarch64-linux-android21 hello.cpp \
    -o hello

adb push hello /data/local/tmp/hello
adb shell "cd /data/local/tmp; chmod +x ./hello; ./hello"