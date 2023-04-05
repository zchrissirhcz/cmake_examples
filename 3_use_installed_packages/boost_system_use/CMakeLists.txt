cmake_minimum_required(VERSION 3.20)

project(boost_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#system
#find_package(Boost REQUIRED COMPONENTS system)
#find_package(Boost REQUIRED [COMPONENTS <libs>...])
find_package(Boost REQUIRED COMPONENTS filesystem system)

add_executable(testbed testbed.cpp)

#target_link_libraries(testbed PRIVATE Boost::system)

include_directories(${Boost_INCLUDE_DIRS})
target_link_libraries(testbed PRIVATE ${Boost_LIBRARIES})
#target_link_libraries(testbed PRIVATE Boost::system)


message(STATUS "--- Boost_LIBRARIES: ${Boost_LIBRARIES}")