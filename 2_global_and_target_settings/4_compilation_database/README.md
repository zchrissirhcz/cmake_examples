# Compilation Database

## Intro
cmake can gengerate `compile_commands.json` file for GCC/Clang compilers, with compile commands inside. This file is useful for:
- Debugging CMakeLists.txt
- LSP(Language Server Protocal) servers like Clagnd requires this for function and variable jumping
- Tools like sourcetrail use it for parsing and analysing.

We set `CMAKE_EXPORT_COMPILE_COMMANDS` with `ON` or `1` to enable it.

## Per project, in CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)
project(xxx)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # !!
```

## Per project, when invoking cmake
```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

## Globally, for all projects
Since cmake 3.17, we can use env var:
```bash
export CMAKE_EXPORT_COMPILE_COMMANDS=1
```

