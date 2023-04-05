@echo off

set BUILD_DIR=vs2019-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

set /p VV=<..\options.txt

cmake ../.. -G "Visual Studio 16 2019" -A x64 %VV%

cd ..
pause