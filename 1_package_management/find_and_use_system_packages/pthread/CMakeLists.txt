cmake_minimum_required(VERSION 3.20)
project(find_pthread_example)

add_executable(demo
  main.cpp
)

# The recommended way:
# Compile FLAGS: -pthread
# Link libraryes: -pthread
# https://stackoverflow.com/questions/1620918/cmake-and-libpthread
# https://github.com/Kitware/CMake/blob/v3.1.0/Modules/FindThreads.cmake#L207
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(demo PUBLIC Threads::Threads)

# For *nix systems, the following works for most time:
# https://zhuanlan.zhihu.com/p/128519905
# set_target_properties(demo PROPERTIES
#   COMPILE_OPTIONS "-pthread"
#   LINK_OPTIONS "-pthread"
# )

# The looks-very-simple-but-not-recommended way:
# -lpthread
# target_link_libraries(demo PRIVATE
#   pthread
# )

# from tv, just link pthread
# link libraries: -lpthread
# find_library(pthread-lib pthread)
# if(pthread-lib)
#   target_link_libraries(demo PRIVATE pthread)
# endif()

# We don't need an variable that stores the path of pthread.h header file
# Because pthread.h is in the same directory of stdio.h