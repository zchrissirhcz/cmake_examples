cmake_minimum_required(VERSION 3.14)

project(example)


#include("gflags-example.cmake")
#include("glog-example.cmake")
#include("protobuf-example.cmake")
#include("hdf5-example.cmake")
#include("lmdb-example.cmake")

include("leveldb-example.cmake")


# `myapp` is used as a test target
#add_executable(myapp src/main.c)
#include("opencv.cmake")
#include("glew.cmake")
#include("glfw.cmake")
