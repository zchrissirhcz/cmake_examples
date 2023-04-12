@echo off

set BUILD_DIR=vs2019-x64

cmake -S .. -B %BUILD_DIR% -G "Visual Studio 16 2019" -A x64

@REM build
cmake --build %BUILD_DIR% --config Debug
cmake --build %BUILD_DIR% --config Release

@REM install
@REM --prefix xxx is optional
@REM cmake --install %BUILD_DIR% --config Debug --prefix d:/lib/xxx
@REM cmake --install %BUILD_DIR% --config Release --prefix d:/lib/xxx


pause