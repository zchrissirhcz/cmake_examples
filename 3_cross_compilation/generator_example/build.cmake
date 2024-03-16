# Use this script with:
# cmake -P ./build.cmake

cmake_minimum_required(VERSION 3.25)

# ok
# execute_process(
#   COMMAND 
#     ${CMAKE_COMMAND} -G "Ninja" -S . -B build-cmake
# )

# fail
# Argument not separated from preceding token by whitespace.
# This warning is for project developers.  Use -Wno-dev to suppress it.
# execute_process(
#   COMMAND 
#     "${CMAKE_COMMAND} -G "Ninja" -S . -B build-cmake"
# )

# multiline: ok
execute_process(
  COMMAND ${CMAKE_COMMAND}
    -G "Ninja"
    -S .
    -B build-cmake
)

# configure args as list of double quoted strings: ok
# set(cmake_configure_args "-G" "Ninja" "-S" "." "-B" "build-cmake")
# execute_process(
#   COMMAND ${CMAKE_COMMAND} ${cmake_configure_args}
# )

# configure args as list of not-quoted strings: ok
# set(cmake_configure_args
#   -G "Ninja"
#   -S .
#   -B build-cmake
# )
# execute_process(
#   COMMAND ${CMAKE_COMMAND} ${cmake_configure_args}
# )

# configure args by appending to list: ok
# set(cmake_configure_args)
# list(APPEND cmake_configure_args "-G Ninja")
# list(APPEND cmake_configure_args "-S .")
# list(APPEND cmake_configure_args "-B build-cmake")
# message("cmake_configure_args: ${cmake_configure_args}")
# execute_process(
#   COMMAND ${CMAKE_COMMAND} ${cmake_configure_args}
# )

# configure args added once by one: ok
# set(cmake_configure_args)
# list(APPEND cmake_configure_args "-G")
# list(APPEND cmake_configure_args "Ninja")
# list(APPEND cmake_configure_args "-S")
# list(APPEND cmake_configure_args ".")
# list(APPEND cmake_configure_args "-B")
# list(APPEND cmake_configure_args "build-cmake")
# message("cmake_configure_args: ${cmake_configure_args}")
# execute_process(
#   COMMAND ${CMAKE_COMMAND} ${cmake_configure_args}
# )

# we may also use --build option to build the project
# execute_process(
#     COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}/subproject_build
# )
