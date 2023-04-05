cmake_minimum_required(VERSION 3.20)
project(example)
set(CMAKE_CXX_STANDARD 11)
add_executable(testbed main.cpp)

set(FreeGLUT_DIR "D:/artifacts/freeglut/3.2.1/vs2019-x64/lib/cmake/FreeGLUT")
find_package(FreeGLUT REQUIRED)
target_link_libraries(testbed FreeGLUT::freeglut)

set_target_properties(testbed PROPERTIES
    VS_DEBUGGER_WORKING_DIRECTORY "D:/artifacts/freeglut/3.2.1/vs2019-x64/bin"
)