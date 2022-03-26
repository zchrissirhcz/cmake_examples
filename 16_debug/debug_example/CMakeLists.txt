cmake_minimum_required(VERSION 3.20)

project(x)

set(ncnn_DIR "/home/zz/artifacts/ncnn/20211208/ncnn-20211208-android-vulkan/arm64-v8a/lib/cmake/ncnn")
find_package(ncnn REQUIRED)

include(deps.cmake)

include(../debug.cmake)

set(CMAKE_CXX_STANDARD 11)

add_executable(testbed testbed.cpp)

add_library(my_eigen INTERFACE
  my_eigen.h
)

my_print_target_properties(ncnn)
#print_target_properties(testbed)
#echo_target(testbed)


#echo_targets(testbed)


# my_print_target(ncnn)
# my_print_target(testbed)
# my_print_target(my_eigen)
# my_print_target(opencv_core)
#my_print_target(${OpenCV_LIBS})


# foreach(tgt ${OpenCV_LIBS})
#   my_print_target(${tgt})
# endforeach()

message(STATUS "opencv_libs: ${OpenCV_LIBS}")

#set(my_target_lst "ncnn;testbed")
#set(my_target_lst "ncnn testbed")
set(my_target_lst
  ncnn
  testbed
  Vulkan::Vulkan
  glslang
  SPIRV
  MachineIndependent
  #android
  #jnigraphics
  #log
)
my_print_target_list_properties(${my_target_lst})
#my_print_targets(${OpenCV_LIBS})

my_print_target_properties(opencv_imgcodecs)

# message(STATUS "================")

# print_target_properties(opencv_imgcodecs)

#my_print_global_properties()


# my_print_target_properties(quirc)
my_print_imported_targets()
if(ANDROID)
  my_print_target_properties(libpng)
endif()
my_print_target_properties(opencv_imgcodecs)