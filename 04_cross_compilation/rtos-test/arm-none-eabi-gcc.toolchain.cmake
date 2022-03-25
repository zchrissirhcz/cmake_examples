#modified from https://github.com/vpetrigo/arm-cmake-toolchains

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

set(TOOLCHAIN_PREFIX arm-none-eabi-)

execute_process(
  COMMAND ${UTIL_SEARCH_CMD} ${TOOLCHAIN_PREFIX}gcc
  OUTPUT_VARIABLE BINUTILS_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

message(STATUS ">>> BINUTILS_PATH is : ${BINUTILS_PATH}")

get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
# Without that flag CMake is not able to pass test compilation check
if(${CMAKE_VERSION} VERSION_EQUAL "3.6.0" OR ${CMAKE_VERSION} VERSION_GREATER "3.6")
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
else()
    set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
endif()

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)

set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}size CACHE INTERNAL "size tool")

set(CMAKE_SYSROOT ${ARM_TOOLCHAIN_DIR}/../arm-none-eabi)
set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


#if("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
#    string(APPEND CMAKE_EXE_LINKER_FLAGS " -nostdlib")
#    string(APPEND CMAKE_EXE_LINKER_FLAGS " -L${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/lib/thumb/v7-m/nofp")
#    string(APPEND CMAKE_EXE_LINKER_FLAGS " -L${ARM_TOOLCHAIN_DIR}/../lib/gcc/arm-none-eabi/8.2.1/thumb/v7-m/nofp")
#   string(APPEND CMAKE_EXE_LINKER_FLAGS " -lgcc -lnosys -lc")
#elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
#string(REGEX MATCH ".*\.specs.*" has_specs "${CMAKE_EXE_LINKER_FLAGS}")
#
#    if(NOT has_specs)
#        string(APPEND CMAKE_EXE_LINKER_FLAGS " --specs=nosys.specs")
#    endif()
#    #endif()
set(CMAKE_EXE_LINKER_FLAGS "--specs=nosys.specs")
