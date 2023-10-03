@echo off

@REM https://stackoverflow.com/questions/6319274/how-do-i-run-msbuild-from-the-command-line-using-windows-sdk-7-1
set MSBUILD="C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBUILD.exe"
%MSBUILD%
.\x64\Debug\ConsoleApplication1.exe
