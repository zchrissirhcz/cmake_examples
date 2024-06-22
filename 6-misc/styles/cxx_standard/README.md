## global

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

## Per-target

Bad:
```cmake
target_compile_options(your_target PRIVATE -std=c++11)
```

Good:
```cmake
set_target_properties(your_target PROPERTIES CXX_STANDARD 11)
```