cmake_minimum_required(VERSION 3.17)

project(testbed)

file(GLOB header_files src/*.h)
file(GLOB impl_files src/*.cpp)

message(STATUS "--- header files:")
foreach(f ${header_files})
    message(STATUS ${f})
endforeach()

message(STATUS "--- implementation files:")
foreach(f ${impl_files})
    message(STATUS ${f})
endforeach()

add_executable(testbed
    ${header_files}
    ${impl_files}
)