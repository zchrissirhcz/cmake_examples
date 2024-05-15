@echo off

set BUILD_DIR=android-arm64
set DST_DIR=/data/pixel
set EXE_FILE=demo

adb shell "mkdir -p %DST_DIR%"
adb push %BUILD_DIR%/%EXE_FILE% %DST_DIR%
adb shell "cd %DST_DIR%; chmod +x %DST_DIR%/%EXE_FILE%; ./%EXE_FILE%"

