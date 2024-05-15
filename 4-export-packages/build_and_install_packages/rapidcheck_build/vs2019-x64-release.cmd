@echo off

set ARTIFACTS_DIR=E:/artifacts
set BUILD_DIR=vs2019-x64-release
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 16 2019" -A x64 ^
    -DCMAKE_INSTALL_PREFIX=%ARTIFACTS_DIR%/rapidcheck/20211010/vs2019-x64 ^
    -DBUILD_SHARED_LIBS=OFF

cmake --build . --config Release
cmake --install . --config Release
cd ..
pause