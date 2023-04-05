@echo off

set BUILD_DIR=android-arm64
set DST_DIR=/data/local/tmp
@REM set EXE_FILE=test_pointer
set EXE_FILE=test_vext

adb shell "mkdir -p %DST_DIR%"
adb push %BUILD_DIR%/tests/%EXE_FILE% %DST_DIR%
adb shell "cd %DST_DIR%; chmod +x %DST_DIR%/%EXE_FILE%; ./%EXE_FILE%"

pause%

