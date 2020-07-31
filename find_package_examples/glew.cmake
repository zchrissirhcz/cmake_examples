# cmake install provides FindGLEW.cmake
# so, find_package(GLEW) is usually in module mode
if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    # method1
    # set nothing, directly find_package(GLEW REQUIRED)
    # works. since brew installed glew and linked to /usr/local/include and /usr/local/lib
    
    # method2
    # setting GLEW_ROOT cmake variable or environment variable
    # requre cmake>=3.12 and don't turnoff policy 0074
    ## method 2.1  set GLEW_ROOT to installation root directory
    #set(GLEW_ROOT "/Users/chris/work/glew-2.1.0/build/osx/install")
    ## method 2.2 set GLEW_ROOT to installation's subfolder that contain cmake config script
    #set(GLEW_ROOT "/usr/local/Cellar/glew/2.1.0/lib/cmake/glew")

    find_package(GLEW REQUIRED)
    if(GLEW_FOUND)
        message(STATUS "----- GLEW found -----")
        message(STATUS "----- GLEW_INCLUDE_DIRS: ${GLEW_INCLUDE_DIRS}")
        message(STATUS "----- GLEW_LIBRARIES: ${GLEW_LIBRARIES}")
    endif()
endif()
