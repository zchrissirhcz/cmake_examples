cmake_minimum_required(VERSION 3.25)
project(demo)

add_compile_options(-fsanitize=address -fno-omit-frame-pointer -g)
add_link_options(-fsanitize=address -fno-omit-frame-pointer -g)

add_executable(demo
  src/char_array.c
)
