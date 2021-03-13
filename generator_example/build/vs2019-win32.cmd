@echo off

set BUILD_DIR=vs2019-win32

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 16 2019" -A Win32

cd ..

pause