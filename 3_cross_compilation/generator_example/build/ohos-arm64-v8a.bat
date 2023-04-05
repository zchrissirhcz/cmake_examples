@echo off

set OHOS_NDK=D:/soft/Huawei/sdk/native/3.0.0.80
set TOOLCHAIN=%OHOS_NDK%/build/cmake/ohos.toolchain.cmake

REM echo "=== TOOLCHAIN is: $TOOLCHAIN"

set BUILD_DIR=ohos-arm64-v8a
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake -G Ninja ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN% ^
    -DOHOS_ARCH="arm64-v8a" ^
    -DCMAKE_BUILD_TYPE=Debug ^
    ../..

ninja

cd ..
