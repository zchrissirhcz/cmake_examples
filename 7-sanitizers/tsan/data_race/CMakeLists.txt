cmake_minimum_required(VERSION 3.5)
project(data_race)

add_executable(test
  test.cpp # data race
  # test2.cpp # no data race
)
target_compile_options(test PRIVATE -fsanitize=thread -fno-omit-frame-pointer -g)
target_link_options(test PRIVATE -fsanitize=thread)
