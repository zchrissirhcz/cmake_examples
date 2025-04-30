@echo off

set OHOS_NDK=D:/soft/Huawei/sdk/native/3.0.0.80
set TOOLCHAIN=%OHOS_NDK%/build/cmake/ohos.toolchain.cmake

set BUILD_DIR=build-ohos-arm64-v8a

cmake ^
    -S . ^
    -B %BUILD_DIR%
    -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DOHOS_ARCH="arm64-v8a" ^
    -DCMAKE_BUILD_TYPE=Debug

cmake --build %BUILD_DIR%

