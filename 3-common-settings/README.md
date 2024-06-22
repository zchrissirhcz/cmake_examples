## Level of configs
- Global level
- Target level
- Source file level

## Global-Only Configs
- cmake version
- cmake options
- build type

## Global and Target level Configs
- C/C++ language standard
- C/C++ macro definitions
- C/C++ compile options
- C/C++ link options
- including file searching path
- required libraries(names and searching paths)
- library name postfix
- fPIC

## Target-only Configs
- version

## Source file level configs

[`set_source_files_properties()`](https://cmake.org/cmake/help/latest/command/set_source_files_properties.html)

e.g.
```cmake
set_source_files_properties(
  src/xfeat_infer.cpp PROPERTIES
  COMPILE_DEFINITIONS NET_WEIGHTS="${NET_WEIGHTS}" NET_ARCH="${NET_ARCH}"
)
```