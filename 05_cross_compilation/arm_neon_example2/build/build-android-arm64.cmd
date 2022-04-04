@echo off

set ANDROID_NDK=E:/soft/Android/ndk-r21b
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake

REM echo "=== TOOLCHAIN is: $TOOLCHAIN"

set BUILD_DIR=android-arm64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake -G Ninja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DANDROID_LD=lld ^
    -DANDROID_ABI="arm64-v8a" ^
    -DANDROID_PLATFORM=android-24 ^
    ../..

ninja

cd ..