https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html

Prefer using one of `Debug`, `Release`, `MinSizeRel`, `RelWithDebInfo`.
However:
- The quoted ones are also ok, e.g. "Debug"
- Not case-sensitive, e.g. "debug" is OK, "reLEAse" is also ok.

## Specify CMAKE_BUILD_TYPE when invoking CMake

The un-quoted, first letter capitalized:
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=MinSizeRel`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo`

Or, the quoted ones:
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="Debug"`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="Release"`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="MinSizeRel"`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="RelWithDebInfo"`

Or, the all-lower-case string:
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=debug`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=release`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=minsizerel`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=relwithdebinfo`

Or, the all-lower-case string with quotes:
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="debug"`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="release"`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="minsizerel"`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE="relwithdebinfo"`

## Set default CMAKE_BUILD_TYPE in CMakeLists.txt
We pick release type as the default build type. You may switch to other build types.

The un-quoted, first letter capitalized:
```cmake
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build" FORCE)
endif()
```

Or, the quoted ones:
```cmake
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build" FORCE)
endif()
```

Or, the all-lower-case string:
```cmake
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE release CACHE STRING "Choose the type of build" FORCE)
endif()
```

Or, the all-lower-case string with quotes:
```cmake
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "release" CACHE STRING "Choose the type of build" FORCE)
endif()
```

## Specify CMAKE_BUILD_TYPE in CMakeLists.txt
```cmake
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_BUILD_TYPE MinSizeRel)
set(CMAKE_BUILD_TYPE RelWithDebInfo)
```

Or:
```cmake
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_BUILD_TYPE "MinSizeRel")
set(CMAKE_BUILD_TYPE "RelWithDebInfo")
```

Or:
```cmake
set(CMAKE_BUILD_TYPE debug)
set(CMAKE_BUILD_TYPE release)
set(CMAKE_BUILD_TYPE minsizerel)
set(CMAKE_BUILD_TYPE relwithdebinfo)
```

Or:
```cmake
set(CMAKE_BUILD_TYPE "debug")
set(CMAKE_BUILD_TYPE "release")
set(CMAKE_BUILD_TYPE "minsizerel")
set(CMAKE_BUILD_TYPE "relwithdebinfo")
```

## Verify CMAKE_BUILD_TYPE is working
Generate compile_commands.json to verify.