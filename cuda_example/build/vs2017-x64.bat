@echo off

set BUILD_DIR=vs2017-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%
cmake ../.. -G "Visual Studio 15 2017 Win64"
cd ..
pause