include(FetchContent) 
set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps)

#--- tbb
FetchContent_Declare(onetbb #库名字
    GIT_REPOSITORY ${ONETBB_REPO}
    GIT_TAG ${ONETBB_TAG}
)
set(TBB_EXAMPLES OFF CACHE BOOL "")
set(TBB_TEST OFF CACHE BOOL "")
# set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
# set(CMAKE_POLICY_DEFAULT_CMP0079 NEW)
FetchContent_GetProperties(onetbb)

if(NOT tbonetbbb)
    FetchContent_Populate(onetbb)
    add_subdirectory(${onetbb_SOURCE_DIR} ${onetbb_BINARY_DIR})
endif()

FetchContent_MakeAvailable(onetbb)

#--- dnnl
FetchContent_Declare(dnnl #库名字
    GIT_REPOSITORY ${ONEDNN_REPO}
    GIT_TAG ${ONEDNN_TAG}
)

# -DDNNL_LIBRARY_TYPE:STRING=${DNNL_LIBRARY_TYPE}
set(DNNL_BUILD_EXAMPLES OFF CACHE BOOL "")
set(DNNL_CPU_RUNTIME "TBB" CACHE STRING "")
# 需要提前设置 TBBROOT 路径
# set(TBBROOT ${****} CACHE STRING "")
set(DNNL_BUILD_EXAMPLES OFF CACHE BOOL "")
set(DNNL_BUILD_TESTS OFF CACHE BOOL "")
# set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
# set(CMAKE_POLICY_DEFAULT_CMP0079 NEW)
#FetchContent_GetProperties(dnnl)

FetchContent_MakeAvailable(dnnl)
