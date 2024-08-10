@echo off

set BUILD_DIR=vs2019-win32
cmake -S .. -B %BUILD_DIR% -G "Visual Studio 16 2019" -A Win32

pause