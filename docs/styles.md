## Setting C/C++ Standard

### global

Bad:
```cmake
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
```

Still bad:
```cmake
add_compile_options(-std=c++11)
```

Good:
```cmake
set(CMAKE_CXX_STANDARD 11)
```

### Per-target

Bad:
```cmake
target_compile_options(your_target PRIVATE -std=c++11)
```

Good:
```cmake
set_target_properties(your_target PROPERTIES CXX_STANDARD 11)
```

## link directories and libraries

## Global

Bad:
```cmake
link_directories("/usr/local/hello/lib")
```

## Per-target

Bad:
```cmake
target_link_directories(use_hello PUBLIC "/usr/local/hello/lib")
```

Maybe-good:
```cmake
set(hello_DIR "/usr/local/hello/lib/cmake" CACHE PATH "")
find_package(hello REQUIRED)
target_link_libraries(use_hello PUBLIC hello)
```

Better:
```cmake
add_library(hello STATIC IMPORTED GLOBAL)
set_target_properties(hello PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "/usr/local/hello/include"
    IMPORTED_LOCATION "/usr/local/hello/lib/libhello.a"
)
target_link_libraries(use_hello PUBLIC hello)
```