@echo off

set BUILD_DIR=vs2022-win32
cmake -S .. -B %BUILD_DIR% -G "Visual Studio 17 2022" -A Win32


pause