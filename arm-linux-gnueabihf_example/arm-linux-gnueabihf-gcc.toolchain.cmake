set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "arm-linux-gnueabihf-g++")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# other needed options
set(GNUEABIHF_C_FLAGS "-Wall -fPIC -mcpu=cortex-a9 -mfpu=neon-fp16 -mfloat-abi=hard -mthumb-interwork -marm" CACHE INTERNAL docstring)
set(GNUEABIHF_CXX_FLAGS "")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GNUEABIHF_C_FLAGS}" CACHE STRING "C flags" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GNUEABIHF_C_FLAGS} ${NDK_CXX_FLAGS}" CACHE STRING "C++ flags" FORCE)


message(STATUS "=== in toolchain, CMAKE_C_COMPILER is ${CMAKE_C_COMPILER}")

