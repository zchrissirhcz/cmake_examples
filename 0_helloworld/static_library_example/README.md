# static library example

## CMake Syntax Explanation
In the example we demonstrate how a static library file can be created with CMake.

`add_library()` will help us create an library target.

`add_library(hello ` means the library target is named as `hello`. The target name is how we use it in CMakeLists.txt, and it just shares the name (not including the prefix and postfix) of generated library file name.

```cmake
add_library(hello STATIC
  hello.h
  hello.cpp
)
```
The `hello.h` and `hello.cpp` means the target `hello` consists of the two files.

The `STATIC` keyword specifies that it is an static library, instead of an shared library, nor an imported library.

## Advanced stuffs
Creating an static library is easy (as illustrated), but sometimes hard, since you may need:
- Mark **dependencies**: header file searching paths, library files, library paths.
- Add **postfix** for the library file's name, e.g. `hello.lib` for Release type, and `hello_d.lib` for debug type.
- Specify **C/C++ Runtime** for the static library target, i.e. Visual Studio default use MD/MDd, but you may need `MT/MTd` type.
- Create **imported library** target(s), cases when you only have `.h` and `.lib`/`.a` files, does not have corresponding source code.
- Create **header-only libraries**, i.e. no `.c` and no `.cpp` files, only `.h` or `.hpp` files.
- Mark library's other properties, such as:
    - language standard
    - macro definitions
    - compile options
    - version
    - whether globally visible (for `add_subdiretory()` cases)

These stuffs will be covered in the following examples.