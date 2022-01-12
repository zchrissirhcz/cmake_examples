cmake_minimum_required(VERSION 3.20)

project(download_example)

# 若不存在 nb/Timer.h 则下载
# 若本来没有 nb 目录，则会自动创建
# 注意 `file()` 第三个参数必须写，不写则不保存文件
if(NOT EXISTS ${CMAKE_SOURCE_DIR}/nb/Timer.h)
  file(DOWNLOAD "https://raw.githubusercontent.com/scarsty/nb/master/Timer.h" ${CMAKE_SOURCE_DIR}/nb/Timer.h)
endif()

add_executable(hello_nb hello_nb.cpp)


