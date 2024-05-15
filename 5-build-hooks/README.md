# Post Processing Examples

Basic CMake configuration is simple and enough, until you found it interesting that CMake is not easy to handle the following cases:
- Copy required DLL before running executalbes on Windows
- Copy required input files to avoid write "../../" like paths for Visual Studio
- Generate `.cc` and `.h` files from `protoc` (the protobuf compiler) if `.proto` is in subdirectories
- Download asset files before program running
- Generate compute shader files before executing, for Vulkan/OpenGL programs
- ...

This directory provides simple examples that demonstrate each not-easy-to-hand-in-CMake cases.


---


# Testing and Coverage

Writing unittest helps improve software quality. Integrating unittest building with coverage helps you know your test quality well.

The unittest and coverage can be integrated into CMake, then you have the experience of:
```bash
cmake -S . -B build
cd build
make -j4
make test  # here
make coverage # here
```
