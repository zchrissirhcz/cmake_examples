@echo on

::: 通常需要修改如下几个变量，优先级从高到低:
:: ArcAdbTool_DIR
:: SRC_DIR
:: DEVICE_ID

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set ArcAdbTool_DIR=E:\share\from_liuwenlong\build201013\Exe\win32
set MYADB=%ArcAdbTool_DIR%\myadb.exe
set MYNFT=%ArcAdbTool_DIR%\mynft.exe
set MYTEST=%ArcAdbTool_DIR%\mytest.exe
set DEVICE_ID=0123456789ABCDEF

set TargetDeviceShell=%MYADB% -S 172.17.218.164 -s %DEVICE_ID%
set TargetDevicePush=%MYNFT% push -S 172.17.218.164 -s %DEVICE_ID%
set TargetDevicePull=%MYNFT% pull -S 172.17.218.164 -s %DEVICE_ID%
set TargetDeviceTest=%MYTEST% -S 172.17.218.164 -s %DEVICE_ID%
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set SRC_DIR=E:\dbg\zz\cmake_examples\arm_asm_c_mix_example\build\android-arm-64
set DST_DIR=/data/local/tmp/lwl/example_sdk_testbed

::: Ensure directory
%TargetDeviceShell% "mkdir -p %DST_DIR%"

::: Push testbed
::: 这里注意，目标地址，应当写成testbed文件的绝对路径，或者所在目录（并且以/结尾，如果不带/则导致目录被改成了testbed文件，导致执行失败）
::%TargetDevicePush% %SRC_DIR%\testbed %DST_DIR%/
%TargetDevicePush% %SRC_DIR%\hello %DST_DIR%/hello

%TargetDeviceShell% chmod -R 777 %DST_DIR%
%TargetDeviceShell% chmod +x %DST_DIR%/hello

::: Run Testbed with link2device, without VFS mapping
%TargetDeviceTest% %DST_DIR%/hello

::: Run Testbed with link2device, with VFS mapping
::: 注意，Windows路径必须用\分隔，不能用/分隔，并且结尾不能带\；delivery目录是两个\开头；
::%TargetDeviceTest% %DST_DIR%/testbed -M \\hz-delivery\ImageTECH\2018Q4\20806\other\zz\LD_Test /

