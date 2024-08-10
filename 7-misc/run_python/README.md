# Run Python during CMake configuratin/building

This example demonstrates how to call Python in CMakeLists.txt.

This example is quite simple, but using Python from CMakeLists.txt is sometimes very useful, especially when you don't know how to write program in CMake but you can write it up in Python.

## Key output

```
Hello, Python
-- Python result: 0
```

## Full output
```
(base) D:\github\cmake_examples\4_post_processing\run_python>cmake -S . -B build
-- Building for: Visual Studio 17 2022
-- Selecting Windows SDK version 10.0.22000.0 to target Windows 10.0.22621.
-- The C compiler identification is MSVC 19.35.32217.1
-- The CXX compiler identification is MSVC 19.35.32217.1
unity/VC/Tools/MSVC/14.35.32215/bin/Hostx64/x64/cl.exe - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.35.32215/bin/Hostx64/x64/cl.exe - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Found PythonInterp: D:/soft/miniconda3/python.exe (found version "3.10.8")
Hello, Python
-- Python result: 0
-- Configuring done (3.2s)
-- Generating done (0.0s)
-- Build files have been written to: D:/github/cmake_examples/4_post_processing/run_python/build
```