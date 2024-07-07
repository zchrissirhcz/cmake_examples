#!/bin/bash

rm -rf build1
rm -rf build2

cmake -DCMAKE_TOOLCHAIN_FILE=hello1.toolchain.cmake -S . -B build1 -DOHOS_SDK_NATIVE_PATH="/home/zz/toolchains/ohos/native/4.0.10.5" > 1.log 2>&1
cmake -DCMAKE_TOOLCHAIN_FILE=hello2.toolchain.cmake -S . -B build2 -DOHOS_SDK_NATIVE_PATH="/home/zz/toolchains/ohos/native/4.0.10.5" > 2.log 2>&1