# cmake install does not provide Findglfw3.cmake
# so, find_package(glfw3) is in config mode
if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    # method 1
    # set nothing. since brew installed and linked it to /usr/local

    # method 2
    # set glfw3_ROOT variable, pointing to a folder whose root or subfolder
    # contains cmake config file for glfw3
    #set(glfw3_ROOT /Users/chris/work/glfw/build/install)
    
    # method 3
    # set glfw3_DIR variable,
    #set(glfw3_DIR /Users/chris/work/glfw/build/install/lib/cmake/glfw3 CACHE STRING "")
    
    find_package(glfw3 REQUIRED)
    if (glfw3_FOUND)
        message(STATUS "----- glfw3 found -----")
        message(STATUS "----- glfw3_DIR: ${glfw3_DIR}")
        target_link_libraries(myapp glfw)
    endif()
endif()
