# header_only_example

Header-Only means put C/C++ funcions/structs in a .h/.hpp file.

A header file can be treated as an individual, i.e. an library.

Yes, you see all the implmentations of this kind of library.

We use `INTERFACE` keyword when creating an header-only library in CMakeLists:
```cmake
add_library(autotimer INTERFACE # !
  autotimer.hpp
)
```

When setting required include directories, required libraries, for the header-only library target `autotimer`, we have to use `INTERFACE` again:
```cmake
target_include_directories(autotimer INTERFACE # !
  ${CMAKE_CURRENT_SOURCE_DIR}
)
```

When consuming this header-only library, just use it as other targets:
```cmake
target_link_libraries(hello PRIVATE autotimer)
```