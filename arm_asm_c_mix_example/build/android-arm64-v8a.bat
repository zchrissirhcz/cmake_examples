@echo off

set ANDROID_NDK=E:/soft/Android/ndk-r17b
REM export ANDROID_NDK=/Users/chris/soft/android-ndk-r21
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake

REM echo "=== TOOLCHAIN is: $TOOLCHAIN"

set BUILD_DIR=android-arm-64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DANDROID_LD=lld ^
    -DANDROID_ABI="arm64-v8a" ^
    -DANDROID_PLATFORM=android-24 ^
    -DCMAKE_BUILD_TYPE=Release ^
    ../..

ninja

cd ..
