cmake_minimum_required(VERSION 3.5)
project(hello)

set(HELLO "hello" CACHE STRING "")
message(STATUS "HELLO: ${HELLO}")

add_executable(hello hello.c)

