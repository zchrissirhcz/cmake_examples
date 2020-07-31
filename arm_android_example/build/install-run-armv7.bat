@echo off

set DST_DIR="/data/tmp"
adb shell "mkdir -p %DST_DIR%"
adb push armeabi-v7a/demo %DST_DIR%
adb shell "cd %DST_DIR%; chmod +x %DST_DIR%/demo; ./demo"