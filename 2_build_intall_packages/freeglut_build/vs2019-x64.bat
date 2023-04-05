@echo off

set BUILD_DIR=vs2019-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_PREFIX=D:/artifacts/freeglut/3.2.1/vs2019-x64

cmake --build . --config Debug
cmake --install . --config Debug

cmake --build . --config Release
cmake --install . --config Release

pause