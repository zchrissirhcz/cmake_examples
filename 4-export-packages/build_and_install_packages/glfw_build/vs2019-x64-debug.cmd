@echo off

set ARTIFACTS_DIR=E:/artifacts
set BUILD_DIR=vs2019-x64-debug
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 16 2019" -A x64 ^
    -DCMAKE_BUILD_TYPE=Debug ^
    -DCMAKE_DEBUG_POSTFIX=d ^
    -DCMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/glfw/3.3.6/vs2019-x64

cmake --build . --config Debug
cmake --install . --config Debug

cd ..
pause