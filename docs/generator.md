# generator

## intro

Rough graph:
```bash
CMake -> Generators -> Compiler/Linkers
          | -- make        | -- gcc
          | -- ninja       | -- clang
          | -- msbuild     | -- cl.exe
          | -- ...         | -- ...
```

Where each `Generator` relates two contept:
- generator name: `-G xxx`:
    - `-G "Visual Studio 17 2022" -A x64`: msbuild series
    - `-G Ninja`: ninja, single-config
    - `-G "Ninja Multi-Config"`: ninja, multi-config
    - `-G "Unix Makefiles"`: make
- make program: the generator may have different make program. e.g.
    - `-G Ninja -D CMAKE_MAKE_PROGRAM=/path/to/ninja`: use a customized ninja, or ninja is not in PATH
    - `-D Ninja -D CMAKE_MAKE_PROGRAM=samurai`: use samurai instead of ninja

Each generator is not strictly binded to a specify compiler. You may pick the ones you like, such as "Ninja Multi-Config" + "cl.exe".

You may even use a generator for invokation of another generator, such as calling xmake/ninja inside msbuild project files (`xxx.vcxproj`), see [msbuild-call-ninja-in-visual-studio](msbuild-call-ninja-in-visual-studio/README.md)

See [generator_collections/build](generator_collections/build) for a collection of usually used generators.

## single-config generators

```bash
cmake ... -G "Unix Makefiles"
cmake ... -G "Ninja"
```

cmake variable `CMAKE_BUILD_TYPE` works for them.

## multi-config generators

```bash
cmake ... -G "Ninja Multi-Config"
cmake ... -G "Xcode"
cmake ... -G "Visual Studio 17 2022" -A x64
```

cmake variable `CMAKE_CONFIGURATIONS_TYPES` works for them.

## Default generator

When not specify, just see the outout of cmake configration. It must be one of single-config or multi-config generators.