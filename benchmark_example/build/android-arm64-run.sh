#!/bin/bash

BUILD_DIR=android-arm64

testbed()
{
    DST_DIR=/data/local/tmp
    EXE_FILE=testbed
    LOCAL_DIR=/home/zz/data

    adb shell "mkdir -p $DST_DIR"
    adb push $BUILD_DIR/$EXE_FILE $DST_DIR
    adb shell "cd $DST_DIR; chmod +x $DST_DIR/$EXE_FILE; ./$EXE_FILE"

    #adb pull $DEVICE_DIR/rgb2gray_naive.png $SAVE_DIR
}

testbed

