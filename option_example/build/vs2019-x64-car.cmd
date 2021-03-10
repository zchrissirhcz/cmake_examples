@echo off

set BUILD_DIR=vs2019-x64-car

if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 16 2019" -A x64 -DBUILD_CAR=ON
cd ..
pause