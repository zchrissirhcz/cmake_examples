@echo off

set BUILD_DIR=vs2022-x64
set BUILD_TYPE=Release

cmake --build %BUILD_DIR% --config %BUILD_TYPE% --target testbed && .\%BUILD_DIR%\%BUILD_TYPE%\testbed.exe
echo %errorlevel%