#!/bin/bash

BUILD_DIR=android-arm64

testbed()
{
    DST_DIR=/data/local/tmp
    EXE_FILE=testbed

    adb push $BUILD_DIR/$EXE_FILE $DST_DIR
    #adb push ../assets/sky.jpg $DST_DIR
    adb shell "cd $DST_DIR; chmod +x $DST_DIR/$EXE_FILE; ./$EXE_FILE"
}

testbed

