@echo off

set BUILD_DIR=vs2022-win32

if not exist %BUILD_DIR% md %BUILD_DIR%

cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 17 2022" -A Win32

cd ..

pause