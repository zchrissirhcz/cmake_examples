# Install subdir

## Background

When the original authors of a library does not privode perfect cmake export files, you may just use `add_subdirectory()` for quick use. 

However, using `add_subdirectory()` in each of your projects, compiles the third party library, again and again. I don't like it. I would like to compile it once, install once, and use it many times. And the specific version of the library, say "zlib", is not available in most C/C++ package managers:
- vcpkg: always provide the latest version, and it is hard to pick specific versions
- conan: some packages are just missing
- xmake: I don't like lua so I don't use it

So, we have to:
- git clone the third party project's repo
- switch to specific version/tag/branch/commit
- compile it and install it

We may also specify some cmake options, even change some of content of the CMakeLists.txt of the third party project. This make the original repo messy.

Let's write all that settings in a shell script file. Then we have to maintain at least Windows (.cmd/.bat) and Unix(.sh) scripts.

So let's write all that settings in one file, **a root `CMakeLists.txt`**, which use `add_subdirectory()` to build it with our settings, for all platforms. That's elegant.

Everything works smoothly if the third party project is good at CMake. See [1-simple](1-simple) for the simplified case.

## The famous cmake export error

Due to the not-perfect cmake writing, the subdir can be easily compiled, but prone to be error for installation, especially cmake export. Let's reproduce with minimal example, and solve it with various methods.

https://stackoverflow.com/questions/25676277/cmake-target-include-directories-prints-an-error-when-i-try-to-add-the-source


```bash
-- Configuring done (0.3s)
CMake Error in hello/CMakeLists.txt:
  Target "hello" INTERFACE_INCLUDE_DIRECTORIES property contains path:

    "/Users/zz/work/cmake_examples/3-create-packages/4-install-subdir/2-export-failed/hello"

  which is prefixed in the source directory.
```

See [2-export-failed](2-export-failed) directory for minimal reproduce with commands:
```bash
cd 2-export-failed
cmake -S . -B build && cmake --build build --target install
```

## Solutions

- [solve with private transitive](3-solved-with-private-transitive)
- [solve with build interface](4-solved-with-build-interface)
- [solve by clean interface inc dirs](5-solved-by-clean-interface-inc-dirs)
- solve by generate cmake export files manully (Not converted yet)