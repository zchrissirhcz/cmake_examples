if(DEFINED ENV{ARTIFACTS_DIR})
  set(ARTIFACTS_DIR "$ENV{ARTIFACTS_DIR}")
else()
  message(WARNING "ARTIFACTS_DIR env var not defined, abort")
endif()


#--- opencv
if(ANDROID)
  set(OpenCV_DIR "${ARTIFACTS_DIR}/opencv/android-arm64/4.5.5/sdk/native/jni" CACHE PATH "" FORCE)
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  #set(OpenCV_DIR "${ARTIFACTS_DIR}/opencv/linux-x64/${my_ocv_ver}/lib/cmake/opencv4" CACHE PATH "" FORCE)
  #set(OpenCV_DIR "${ARTIFACTS_DIR}/opencv/linux-x64/5.x-dev/lib/cmake/opencv5")

  set(OpenCV_DIR "/home/zz/artifacts/opencv/linux-x64/4.5.5/lib/cmake/opencv4")
  #set(OpenCV_DIR "/home/zz/artifacts/opencv/linux-x64/4.5.5-ipp/lib/cmake/opencv4") # for QA, cv::exp test fail
  #set(OpenCV_DIR "/home/zz/artifacts/opencv/linux-x64/3.4.13/share/OpenCV") # for YuQiWei, seamlessClone
endif()
message(STATUS ">>> OpenCV_DIR: ${OpenCV_DIR}")
find_package(OpenCV REQUIRED)
# if(OpenCV_FOUND)
#     message(STATUS "OpenCV library: ${OpenCV_INSTALL_PATH}")
#     message(STATUS "    version: ${OpenCV_VERSION}")
#     message(STATUS "    libraries: ${OpenCV_LIBS}")
#     message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")
#     if(${OpenCV_VERSION_MAJOR} GREATER 3)
#         set(CMAKE_CXX_STANDARD 11)
#     endif()
# else()
#     message(FATAL_ERROR "Error! OpenCV not found!")
# endif()