@echo off

set DST_DIR="/data/tmp"
adb shell "mkdir -p %DST_DIR%"
adb push arm64-v8a/demo %DST_DIR%
adb push 000001.jpg %DST_DIR%
adb shell "cd %DST_DIR%; chmod +x %DST_DIR%/demo; ./demo"

adb pull /data/tmp/neon.jpg ./
adb pull /data/tmp/non_neon.jpg ./