set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_CXX_COMPILER "arm-linux-gnueabihf-g++")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# compile flags
set(GNUEABIHF_FLAGS "-Wall -fPIC -mfpu=neon -mfloat-abi=hard -ffast-math -ftree-vectorize -std=gnu99" CACHE INTERNAL docstring)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GNUEABIHF_FLAGS}" CACHE STRING "C flags" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GNUEABIHF_FLAGS}" CACHE STRING "C++ flags" FORCE)

