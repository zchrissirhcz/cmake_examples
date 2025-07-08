@echo off

set BUILD_DIR=build-vs2019-x64

cmake ^
  -S . ^
  -B %BUILD_DIR% ^
  -G "Visual Studio 16 2019" -A x64 ^
  -D CMAKE_CXX_FLAGS="/MP"

@REM build
cmake --build %BUILD_DIR% --config Debug -- /p:CL_MP=true /p:CL_MPCount=4
cmake --build %BUILD_DIR% --config Release -- /p:CL_MP=true /p:CL_MPCount=4

@REM install
@REM --prefix xxx is optional
@REM cmake --install %BUILD_DIR% --config Debug --prefix d:/lib/xxx
@REM cmake --install %BUILD_DIR% --config Release --prefix d:/lib/xxx


pause