@echo off

set ANDROID_NDK=D:/soft/android-ndk/r21e
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake

set BUILD_DIR=build-android-arm64

cmake ^
    -S . ^
    -B %BUILD_DIR% ^
    -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DANDROID_LD=lld ^
    -DANDROID_ABI="arm64-v8a" ^
    -DANDROID_PLATFORM=android-24 ^
    -DCMAKE_BUILD_TYPE=Release

cmake --build %BUILD_DIR%
