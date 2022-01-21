set(HDF5_DIR "D:/lib/hdf5/1.8.16/x64/vc12/cmake")

set (LIB_TYPE STATIC) # or SHARED
string(TOLOWER ${LIB_TYPE} SEARCH_TYPE)

find_package (HDF5 NAMES hdf5)
if (HDF5_FOUND)
    message(STATUS "----- HDF5 found")
    message(STATUS "----- HDF5_INCLUDE_DIR: ${HDF5_INCLUDE_DIR}")
else()
    message(STATUS "----- HDF5 not found")
endif()
# find_package (HDF5) # Find non-cmake built HDF5
include_directories(${HDF5_INCLUDE_DIR})
set (LINK_LIBS ${LINK_LIBS} ${HDF5_C_${LIB_TYPE}_LIBRARY})

set (example hdf5_example)

add_executable (${example} ${PROJECT_SOURCE_DIR}/src/${example}.c)
target_link_libraries (${example} ${LINK_LIBS})
