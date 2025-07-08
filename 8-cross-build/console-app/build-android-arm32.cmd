@echo off

set ANDROID_NDK=D:/soft/android-ndk/r21e
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake

set BUILD_DIR=build-android-arm32

cmake ^
    -S . ^
    -B %BUILD_DIR% ^
    -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DANDROID_LD=lld ^
    -DANDROID_ABI="armeabi-v7a" ^
    -DANDROID_ARM_NEON=ON ^
    -DANDROID_PLATFORM=android-21 ^
    -DCMAKE_BUILD_TYPE=Release

cmake --build %BUILD_DIR%