# debug_symbol_example

This example shows how to correctly add `-g`, the debug symbol flag, in a CMake manner.

Due to the CMAKE_BUILD_TYPE you have specified, you have to add `-g` to correspoinding variables:
- CMAKE_CXX_FLAGS
- CMAKE_CXX_FLAGS_DEBUG
- CMAKE_CXX_FLAGS_RELEASE
- CMAKE_CXX_FLAGS_RELWITHDEBINFO
- CMAKE_CXX_FLAGS_MINSIZEREL

Though appending `-g` to `CMAKE_CXX_FLAGS` works for debugging and set break points, but it is not straightforward for checking if `-g` is turn on in a CMake manner.

I have encapsulated the very handy cmake operations in [manage_flags.cmake](manage_flags.cmake), just include it and call correspoinding functions, make your life easy!
```cmake
include(manage_flags.cmake)
# - check_exist_debug_symbol() # 检查当前 CMAKE_BUILD_TYPE 下的 （CXX） flags 是否有开启调试符号
# - drop_debug_symbol()        # 在当前 CMAKE_BUILD_TYPE 下， 给 C 和 C++ 删除调试符号选项
# - add_debug_symbol()         # 在当前 CMAKE_BUILD_TYPE 下， 给 C 和 C++ 增加调试符号选项
# - print_cxx_flags()          # 打印所有 CMAKE_BUILD_TYPE 下的 C++ Flags
# - print_c_flags()            # 打印所有 CMAKE_BUILD_TYPE 下的 C Flags
# - print_linker_flags()       # 打印所有 CMAKE_BUILE_TYPE 下的 linker flags
```