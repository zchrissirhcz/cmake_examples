# Get EasyX from https://easyx.cn/download
add_library(easyx STATIC IMPORTED GLOBAL)
set_target_properties(easyx PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/lib/VC2015/x64/EasyXa.lib"
)