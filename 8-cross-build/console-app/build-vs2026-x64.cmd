@echo off

set BUILD_DIR=build-vs2026-x64
cmake ^
  -S . ^
  -B %BUILD_DIR% ^
  -G "Visual Studio 18 2026" -A x64

@REM build
cmake --build %BUILD_DIR% --config Debug
cmake --build %BUILD_DIR% --config Release

@REM install
@REM --prefix xxx is optional
@REM cmake --install %BUILD_DIR% --config Debug --prefix d:/lib/xxx
@REM cmake --install %BUILD_DIR% --config Release --prefix d:/lib/xxx

pause