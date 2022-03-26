@echo off

set BUILD_DIR=vs2013-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 12 2013 Win64"

@REM build
cmake --build . --config Debug
cmake --build . --config Release

@REM install
@REM --prefix xxx is optional
@REM cmake --install . --config Debug --prefix d:/lib/xxx
@REM cmake --install . --config Release --prefix d:/lib/xxx

cd ..

pause