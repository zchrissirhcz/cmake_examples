set(GFLAGS_DIR "D:/lib/gflags/2.2.2/x64/vc12/lib/cmake/gflags")

find_package(gflags COMPONENTS nothreads_static)
if(gflags_FOUND)
  message(STATUS "===== Found gflags")
  message(STATUS "----- GFLAGS_INCLUDE_DIR: ${GFLAGS_INCLUDE_DIR}")
endif()

add_executable(gflags_example src/gflags_example.cpp)
target_link_libraries(gflags_example gflags)
