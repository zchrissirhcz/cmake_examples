cmake_minimum_required(VERSION 3.15)

project(demo)
set(CMAKE_BUILD_TYPE "Release")

set(dep_libs "")

#--- OpenMP
if(NOT ANDROID)
    find_package(OpenMP)
    if(NOT TARGET OpenMP::OpenMP_CXX AND (OpenMP_CXX_FOUND OR OPENMP_FOUND))
        target_compile_options(${PROJECT_NAME} PRIVATE ${OpenMP_CXX_FLAGS})
    endif()

    if(OpenMP_CXX_FOUND OR OPENMP_FOUND)
        message(STATUS "Building with OpenMP")
        if(OpenMP_CXX_FOUND)
            list(APPEND dep_libs PUBLIC OpenMP::OpenMP_CXX)
        else()
            list(APPEND dep_libs PRIVATE "${OpenMP_CXX_FLAGS}")
        endif()
    endif()
endif()

add_executable(demo
    src/main.cpp
)

if (ANDROID)
    #https://github.com/Tencent/ncnn/issues/1771#issuecomment-639214378
    target_link_libraries(demo -static-openmp -fopenmp) 
else()
    message(STATUS "dep_libs: ${dep_libs}")
    target_link_libraries(demo ${dep_libs})
endif()
