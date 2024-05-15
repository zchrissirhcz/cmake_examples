@echo off

REM set ANDROID_NDK=E:/soft/Android/ndk-r17b
set ANDROID_NDK=E:/soft/Android/ndk-r21e
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake

REM echo "=== TOOLCHAIN is: $TOOLCHAIN"

set BUILD_DIR=armeabi-v7a
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DANDROID_LD=lld ^
    -DANDROID_ABI="armeabi-v7a" ^
    -DANDROID_ARM_NEON=ON ^
    -DANDROID_PLATFORM=android-24 ^
    -DCMAKE_BUILD_TYPE=Release ^
    ../..

ninja

cd ..