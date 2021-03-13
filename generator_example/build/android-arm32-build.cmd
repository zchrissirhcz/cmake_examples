@echo off

if not defined ANDROID_NDK (
    set ANDROID_NDK=E:/soft/Android/ndk-r21b
)
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake

echo "ANDROID_NDK is %ANDROID_NDK%"
echo "TOOLCHAIN is: %TOOLCHAIN%"

set BUILD_DIR=android-arm32
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