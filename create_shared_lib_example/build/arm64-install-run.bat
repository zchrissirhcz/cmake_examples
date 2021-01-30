@echo off

set BUILD_DIR=android-arm64
set DST_DIR=/data/age_generation
@REM set SO_FILE=libEyeglassRemoval_Processor.so
set EXE_FILE=testbed
set COPY_IMAGES=false

adb shell "mkdir -p %DST_DIR%"
adb shell "mkdir -p %DST_DIR%/test_img"
adb push %BUILD_DIR%/libget_three.so %DST_DIR%
adb push %BUILD_DIR%/libget_seven.so %DST_DIR%
adb push %BUILD_DIR%/%EXE_FILE% %DST_DIR%

if %COPY_IMAGES% == true (
  adb push ../assets/image/000323.jpg %DST_DIR%/test_img/
  adb push ../assets/image/000373.jpg %DST_DIR%/test_img/
  adb push ../assets/image/000278.jpg %DST_DIR%/test_img/
  adb push ../assets/image/000032.jpg %DST_DIR%/test_img/
  adb push ../assets/image/g.jpg %DST_DIR%/test_img/
  adb push ../assets/image/dir_android.txt %DST_DIR%/test_img/
)

adb shell "cd %DST_DIR%; chmod +x %DST_DIR%/%EXE_FILE%; export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH; ./%EXE_FILE%"

@REM adb pull %DST_DIR%/test_img/000323_result.jpg ./
@REM adb pull %DST_DIR%/test_img/000373_result.jpg ./
@REM adb pull %DST_DIR%/test_img/000278_result.jpg ./
@REM adb pull %DST_DIR%/test_img/000032_result.jpg ./

@REM adb pull %DST_DIR%/test_img/g_result.jpg ./