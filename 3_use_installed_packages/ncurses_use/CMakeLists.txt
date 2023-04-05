cmake_minimum_required(VERSION 3.20)
project(ncurses_use)

set(CMAKE_C_STANDARD 99)

add_executable(testbed
  testbed.c
)

find_package(Curses REQUIRED)

target_include_directories(testbed PUBLIC
  ${CURSES_INCLUDE_DIRS}
)

target_link_libraries(testbed PUBLIC
  ${CURSES_LIBRARIES}
)