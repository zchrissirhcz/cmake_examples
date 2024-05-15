# CMake Tools

## 1. `xxx.cmake`
A collection of cmake tools. Use each of them as an plugin, e.g.
```cmake
include(asan.cmake)
```

## 2. `cmake_sanitizer.py`
Statically checking specified `CMakeLists.txt` is ill or OK:
```bash
python cmake_sanitizer.py /path/to/CMakeLists.txt
```