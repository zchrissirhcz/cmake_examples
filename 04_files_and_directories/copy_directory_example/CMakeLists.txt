cmake_minimum_required(VERSION 3.20)

project(copy_directory_example)

add_executable(testbed testbed.cpp)

add_custom_command(TARGET testbed
  POST_BUILD

  # 注意：目标目录也写了同名的 data， 才会复合预期。
  # 若目标目录没写到 data, 则仅仅是把源目录里的文件复制过去
  # 拷贝会递归进行，即： 子目录也被正确拷贝过去
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/data ${CMAKE_BINARY_DIR}/data
)


# execute_process(
#   COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/data ${CMAKE_BINARY_DIR}/data
# )