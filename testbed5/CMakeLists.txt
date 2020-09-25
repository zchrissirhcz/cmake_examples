cmake_minimum_required(VERSION 3.15)

project(demo)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


add_executable(demo src/demo.cpp)

if(MSVC)
    set(JPEG_ROOT "E:/lib/libjpeg/x64/vc15")
else()
    message(FATAL_ERROR "not implemented yet !")
endif()
set(JPEG_INCLUDE_DIR "${JPEG_ROOT}/include")
set(JPEG_LIBRARY_DIR "${JPEG_ROOT}/lib")
set(JPEG_BINARY_DIR "${JPEG_ROOT}/bin")
set(JPEG_USE_STATIC_LIBS ON)

if(JPEG_USE_STATIC_LIBS)
    add_library(JPEG::JPEG STATIC IMPORTED)
else()
    add_library(JPEG::JPEG SHARED IMPORTED)
endif()


if(MSVC)
    if(JPEG_USE_STATIC_LIBS)
        set_target_properties(JPEG::JPEG PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIR}"
            IMPORTED_LOCATION_DEBUG "${JPEG_LIBRARY_DIR}/jpegd.lib"
            IMPORTED_LOCATION_RELEASE "${JPEG_LIBRARY_DIR}/jpeg.lib"

            MAP_IMPORTED_CONFIG_MINSIZEREL Release
            MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
        )
    else()
        set_target_properties(JPEG::JPEG PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIR}"
            IMPORTED_IMPLIB_DEBUG "${JPEG_LIBRARY_DIR}/jpegd.lib"
            IMPORTED_IMPLIB_RELEASE "${JPEG_LIBRARY_DIR}/jpeg.lib"

            IMPORTED_LOCATION_DEBUG "${JPEG_BINARY_DIR}/jpegd.dll"
            IMPORTED_LOCATION_RELEASE "${JPEG_BINARY_DIR}/jpeg.dll"

            MAP_IMPORTED_CONFIG_MINSIZEREL Release
            MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
        )
        get_target_property(JPEG_DEBUG_DLL JPEG::JPEG IMPORTED_LOCATION_DEBUG)
        get_target_property(JPEG_RELEASE_DLL JPEG::JPEG IMPORTED_LOCATION_RELEASE)
        set(JPEG_DLL
            $<$<CONFIG:Debug>:"${JPEG_DEBUG_DLL}">
            $<$<CONFIG:Release>:"${JPEG_RELEASE_DLL}">
        )
    endif()
endif()


target_include_directories(demo PUBLIC)
target_link_libraries(demo JPEG::JPEG)

add_custom_command(TARGET demo
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${CMAKE_SOURCE_DIR}/girl.jpg
    ${CMAKE_BINARY_DIR}/
)

if(MSVC AND NOT JPEG_USE_STATIC_LIBS) # copy dll
    add_custom_command(TARGET demo
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${JPEG_DLL}
        ${CMAKE_BINARY_DIR}/
    )
endif()

# add_custom_command(TARGET demo
#     POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different
#     ${CMAKE_SOURCE_DIR}/girl.jpg
#     ${CMAKE_BINARY_DIR}/
# )

# if(MSVC AND NOT PNG_USE_STATIC_LIBS) # copy dll
#     add_custom_command(TARGET demo
#         POST_BUILD
#         COMMAND ${CMAKE_COMMAND} -E copy_if_different
#         ${PNG_DLL}
#         ${CMAKE_BINARY_DIR}/
#     )
# endif()
