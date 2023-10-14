cmake_minimum_required(VERSION 3.20)
project(x)

add_executable(demo
  main.cpp
)

# -lpthread
# target_link_libraries(demo PRIVATE
#   pthread
# )

# Compile FLAGS: -pthread
# LINK_FLAGS: -pthread
# https://zhuanlan.zhihu.com/p/128519905
# set_target_properties(demo PROPERTIES
#   COMPILE_FLAGS "-pthread"
#   LINK_FLAGS "-pthread"
# )

# Compile FLAGS: -pthread
# Link libraryes: -pthread
# https://stackoverflow.com/questions/1620918/cmake-and-libpthread
# https://github.com/Kitware/CMake/blob/v3.1.0/Modules/FindThreads.cmake#L207
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(demo PRIVATE Threads::Threads)

# from tv
# link libraries: -lpthread
# find_library(pthread-lib pthread)
# if(pthread-lib)
#   target_link_libraries(demo PRIVATE pthread)
# endif()

# We don't need an variable that stores the path of pthread.h header file
# Because dlfcn.h is in the same directory of stdio.h