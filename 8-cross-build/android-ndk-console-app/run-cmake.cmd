@echo off

set NDK=C:/soft/android-ndk/r27c
set BUILD_DIR=build

cmake ^
    -S . ^
    -B %BUILD_DIR% ^
    -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%NDK%/build/cmake/android.toolchain.cmake ^
    -DANDROID_ABI=arm64-v8a ^
    -DANDROID_PLATFORM=21 ^
    -DCMAKE_BUILD_TYPE=Release

cmake --build %BUILD_DIR%