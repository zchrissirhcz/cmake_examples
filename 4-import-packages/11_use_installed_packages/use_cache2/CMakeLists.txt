cmake_minimum_required(VERSION 3.10)
project(catch2test)

set(Catch2_DIR "/Users/zz/.zzpkg/Catch2/3.7.1/lib/cmake/Catch2" CACHE PATH "Directory that contains Catch2Config.cmake")
find_package(Catch2 CONFIG REQUIRED)

include(CTest)
include(Catch)

add_executable(tests test.cpp)
target_link_libraries(tests PRIVATE Catch2::Catch2WithMain)

catch_discover_tests(tests)
