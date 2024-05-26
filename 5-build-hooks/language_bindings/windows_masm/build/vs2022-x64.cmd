@echo off

set BUILD_DIR=vs2022-x64
if not exist %BUILD_DIR% md %BUILD_DIR%
cd %BUILD_DIR%

cmake ../.. -G "Visual Studio 17 2022" -A x64

@REM build
cmake --build . --config Debug
cmake --build . --config Release

@REM install
@REM --prefix xxx is optional
@REM cmake --install . --config Debug --prefix d:/lib/xxx
@REM cmake --install . --config Release --prefix d:/lib/xxx

cd ..

pause