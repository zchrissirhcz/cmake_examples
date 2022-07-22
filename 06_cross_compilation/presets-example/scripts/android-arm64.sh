#!/bin/bash

configure()
{
    cmake --preset android-arm64-release
}

build()
{
    cmake --build --preset android-arm64-release
}

run()
{
    BUILD_DIR=out/build/android-arm64-release
    DST_DIR=/data/local/tmp

    adb push $BUILD_DIR/testbed $DST_DIR
    adb shell "cd $DST_DIR; chmod +x testbed; ./testbed"
}

configure && build && run
