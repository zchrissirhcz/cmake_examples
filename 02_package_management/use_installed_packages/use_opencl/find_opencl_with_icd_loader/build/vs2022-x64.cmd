@echo off

set BUILD_DIR=vs2022-x64
set CVBUILD_PLATFORM=vs2022
set CVBUILD_ARCH=x64

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 17 2022" -A x64

cd ..

pause

