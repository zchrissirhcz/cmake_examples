@echo off

set BUILD_DIR=vs2019-x64
set CVBUILD_PLATFORM=vs2019
set CVBUILD_ARCH=x64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 16 2019" -A x64

cd ..

pause

