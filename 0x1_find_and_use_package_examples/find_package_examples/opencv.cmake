# cmake install does not provide FindOpenCV.cmake
# so, find_package(OpenCV) is in config mode
if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    # method1
    # set nothing. use brew installed opencv

    # method2
    # set OpenCV_ROOT variable. need cmake>=3.12
    set(OpenCV_ROOT $ENV{HOME}/work/opencv-3.4.5/build/install)

    # method3
    # set OpenCV_DIR variable.
    #set(OpenCV_DIR $ENV{HOME}/work/opencv-3.4.5/build/install CACHE STRING "")

    find_package(OpenCV REQUIRED
        #NO_CMAKE_PATH
        #NO_CMAKE_ENVIRONMENT_PATH
        #NO_SYSTEM_ENVIRONMENT_PATH
        #NO_CMAKE_PACKAGE_REGISTRY
        #NO_CMAKE_SYSTEM_PATH
    )
    if (OpenCV_FOUND)
        message(STATUS "----- OpenCV found -----")
        message(STATUS "OpenCV package status:")
        message(STATUS "    version: ${OpenCV_VERSION}")
        message(STATUS "    libraries: ${OpenCV_LIBS}")
        message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")
        message(STATUS "    OpenCV_SHARED: ${OpenCV_SHARED}")
    endif()
endif()
