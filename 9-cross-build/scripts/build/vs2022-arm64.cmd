@echo off

set BUILD_DIR=vs2022-arm64
cmake ^
  -S .. ^
  -B %BUILD_DIR% ^
  -G "Visual Studio 17 2022" -A ARM64

cmake --build %BUILD_DIR%