# Concepts

[TOC]

## cmake_minimum_required

## project

## target

- executable: `add_executable()`
- static library: `add_library(xx STATIC)`
- shared library: 
    - `add_library(xx SHARED)`
    - `BUILD_SHARED_LIBS` cmake variable

- alias target
- global target
- imported target
- interface target

## variable

- variable
- cache variable
- environment variables
- cmake options

## generator

[generator.md](generator.md)

## install

- `CMAKE_INSTALL_PREFIX`
- `install(EXPORT)`

## Debug && Release

- `CMAKE_BUILD_TYPE`: Debug, Release, MinSizeRel, RelWithDebInfo
- `CMAKE_CONFIGURATION_TYPES`:

- single-config generator
- multi-config generator: `-G Ninja Multi-Config`, `-G "Visual Studio 17 2022" -A x64`, `-G Xcode`


## subdirectory

[subdirectory.md](subdirectory.md)

## configure_file

## Find .dll/.so files

- RPATH
- VS_DEBUGGER_ENVIRONMENT_VARIABLE

## transitive usage requirements

- `PUBLIC`
- `PRIVATE`
- `INTERFACE`

- `$<BUILD_INTERFACE:>`
- `$<INSTALL_INTERFACE:>`
- `CONFIG` as template for actual `CMAKE_BUILD_TYPE`