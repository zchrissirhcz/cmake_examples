@echo off

set ANDROID_NDK=D:/soft/android-ndk/r21e
set TOOLCHAIN=%ANDROID_NDK%/build/cmake/android.toolchain.cmake
set MAKE=%ANDROID_NDK%/prebuilt/windows-x86_64/bin/make.exe

echo "ANDROID_NDK is %ANDROID_NDK%"
echo "TOOLCHAIN is: %TOOLCHAIN%"
echo "MAKE is: %MAKE%"

@REM Note: generated is switched from Ninja to CodeBlocks - MinGW Makefiles
@REM CMAKE_MAKE_PROGRAM is required to be specified, or cmake will fail
@REM after running cmake, there is xxx.cbp generated, similar with xxx.sln

set BUILD_DIR=build-android-arm64

cmake ^
    -S . ^
    -B %BUILD_DIR% ^
    -G "CodeBlocks - MinGW Makefiles" ^
    -DCMAKE_MAKE_PROGRAM=%MAKE% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DANDROID_LD=lld ^
    -DANDROID_ABI="arm64-v8a" ^
    -DANDROID_PLATFORM=android-24 ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
    -DOpenCV_DIR=E:/soft/Android/opencv-4.5.0-android-sdk/sdk/native/jni

cmake --build %BUILD_DIR%
