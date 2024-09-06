#!/bin/bash

configure()
{
    cmake --preset android-arm32-release
}

build()
{
    cmake --build --preset android-arm32-release
}

run()
{
    BUILD_DIR=out/build/android-arm32-release
    DST_DIR=/data/local/tmp

    adb push $BUILD_DIR/testbed $DST_DIR
    adb shell "cd $DST_DIR; chmod +x testbed; ./testbed"
}

configure && build && run
