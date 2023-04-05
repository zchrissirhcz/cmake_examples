cmake_minimum_required(VERSION 3.20)

project(lmdb_use)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(LMDB_DIR "D:/artifacts/lmdb/0.9.18/windows/vs2019-x64/cmake" CACHE PATH "")

find_package(LMDB)
if(LMDB_FOUND)
    message(STATUS "----- LMDB found")
    message(STATUS "----- LMDB_LIBRARIES: ${LMDB_LIBRARIES}")
    message(STATUS "----- LMDB_INCLUDE_DIRS: ${LMDB_INCLUDE_DIRS}")
endif()

add_executable(testbed testbed.cpp)
target_include_directories(testbed PRIVATE ${LMDB_INCLUDE_DIRS})

target_link_libraries(testbed ${LMDB_LIBRARIES})
#Threads::Threads) #

execute_process(COMMAND mkdir testdb)
