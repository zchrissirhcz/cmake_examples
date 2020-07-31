if(MSVC)
    #set(LMDB_DIR "F:/zhangzhuo/caffe-deps/lmdb-cmake/build/vs2013-x64/install/x64/vc12/cmake" CACHE PATH "")
    set(LMDB_DIR "D:/lib/lmdb/0.9.18/x64/vc12/cmake" CACHE PATH "")
elseif(UNIX)
    set(LMDB_DIR "/home/zz/work/lmdb-cmake/build/linux/install/cmake" CACHE PATH "")
endif()

if(UNIX)
    message(STATUS "----- This is unix")
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
endif()

find_package(LMDB)
if (LMDB_FOUND)
    message(STATUS "----- LMDB found")
    message(STATUS "----- LMDB_LIBRARIES: ${LMDB_LIBRARIES}")
    message(STATUS "----- LMDB_INCLUDE_DIRS: ${LMDB_INCLUDE_DIRS}")
endif()

add_executable(lmdb_example src/lmdb_example.c)
target_include_directories(lmdb_example PRIVATE ${LMDB_INCLUDE_DIRS})

target_link_libraries(lmdb_example ${LMDB_LIBRARIES})
#Threads::Threads) #

execute_process(COMMAND mkdir testdb)
