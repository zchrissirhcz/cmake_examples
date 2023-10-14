cmake_minimum_required(VERSION 3.20)
project(x)

add_executable(demo main.cpp)

# LINK_LIBRARIES: -ldl
target_link_libraries(demo PRIVATE ${CMAKE_DL_LIBS})

# LINK_LIBRARIES: -ldl
# target_link_libraries(demo PRIVATE dl)

# If on Android NDK < r23 and suffer undefined reference to `__write_chk' error:
# https://github.com/android/ndk/issues/1179
# https://github.com/android/ndk/issues/929
# May consider using this:
# https://gist.github.com/wengxt/d0b02da48aefaf9a9355

# We don't need an variable that stores the path of dlfcn.h header file
# Because dlfcn.h is in the same directory of stdio.h