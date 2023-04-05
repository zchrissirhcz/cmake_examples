# executable example

This cmake example demonstrates how to create an **executable target** "helloworld".

The cpp code(helloworld.cpp) and CMake scripts(CMakeLists.txt) is already prepared. What you need is calling cmake, for the configure and build steps.

## 1. Preparation
Intall CMake, `>= 3.20` recommended.
Install a C/C++ compiler.

## 2. Linux / MacOSX
```bash
cd cmake_examples/01_helloworld
cmake -S . -B build
cmake --build build
./build/helloworld
```
Among which:
- `-S .` specifies the "source directory", which means the directory that contains `CMakeLists.txt` file.
- `-B build` means we specify the configuring and building output files in `build` directory(if it does not exist, will be created automatically).
- `cmake --build build` means we choose the `build` directory's configured result for building.

The `cmake -S . -B build` is the configure step. It actually won't compile our `helloworld.cpp`.
The `cmake --build build` is the building step. It compiles (and also links to C++ runtime) our `helloworld.cpp`.

## 3. Visual Studio
We use Visual Studio 2022 as the IDE, the we have to **specify generator** for cmake, thus it use VS2022 instead of other compilers:

```cmd
cd cmake_examples/01_helloworld
cmake -S . -B build -G "Visual Studio 17 2022" -A x64
cmake --build build
```
The open build/helloworld.sln with Visual Studio 2022, specify `helloworld` project as start item, and press `Ctrl+F5` keys to run.

## 4. Other platform/architecture cross-compilation
For example, Android armv8-a for mobile phone, QNX / TDA4 for ADAS. Just pick proper `xxx-toolchain.cmake` file, and pass it to cmake executable:
```cmake
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE="/path/to/xxx-toolchain.cmake"
```

Different platform/architecture may have different `xxx-toolchain.cmake` file. You may also just ignore this file, and setting `CXX` environment variable to your cross-compiler's full path.

Concrete cross-platform cmake usages will be illustreated in further examples.

## 5. CMake-GUI
Many people choose `cmake-gui.exe` (on Windows) or `ccmake` (on Linux / MacOSX) as cmake GUI, to invoking cmake configuration and building.

I prefer command-line style cmake usage, since it can be scripted, especially in CI/CD, and locally you do same operations as CI/CD does. So, just forget `cmake-gui.exe` and `ccmake`.