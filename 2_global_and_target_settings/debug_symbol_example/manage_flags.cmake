# 用来检查、增加、删除调试符号编译选项（-g）的 CMake 小工具
# 用法:
# - check_exist_debug_symbol() # 检查当前 CMAKE_BUILD_TYPE 下的 （CXX） flags 是否有开启调试符号
# - drop_debug_symbol()        # 在当前 CMAKE_BUILD_TYPE 下， 给 C 和 C++ 删除调试符号选项
# - add_debug_symbol()         # 在当前 CMAKE_BUILD_TYPE 下， 给 C 和 C++ 增加调试符号选项
# - print_cxx_flags()          # 打印所有 CMAKE_BUILD_TYPE 下的 C++ Flags
# - print_c_flags()            # 打印所有 CMAKE_BUILD_TYPE 下的 C Flags
# - print_linker_flags()       # 打印所有 CMAKE_BUILE_TYPE 下的 linker flags

macro(drop_debug_symbol)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    string(REPLACE "-g" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    string(REPLACE "-g" "" CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    string(REPLACE "-g" "" CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_C_FLAGS_RELWITHDEBINFO})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    string(REPLACE "-g" "" CMAKE_C_FLAGS_MINSIZEREL ${CMAKE_C_FLAGS_MINSIZEREL})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL})
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    string(REPLACE "-g" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
    string(REPLACE "-g" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for drop_debug_symbol: ${CMAKE_BUILD_TYPE}")
  endif()
endmacro()


macro(add_debug_symbol)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g")
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g")
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -g")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -g")
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for add_debug_symbol: ${CMAKE_BUILD_TYPE}")
  endif()
endmacro()


# 在字符串 INPUT 中查找 QUERY ， 结果存放在 OUTPUT_VAR 中
# OUTPUT_VAR 的值只有两种可能： TRUE 和 FALSE ， 表示是否找到
function(string_find_element INPUT QUERY OUTPUT_VAR)
  # set(a ${CMAKE_CXX_FLAGS}) # input
  # set(b "-g") # target
  set(a "${INPUT}")
  set(b "${QUERY}")
  set(found_b FALSE)
  string(REPLACE " " ";" c "${a}") # 实现了 items2 到 items1 类型的转换
  foreach(val ${c})
    #message(STATUS "${val}")
    if(${val} STREQUAL "${b}")
      set(found_b TRUE)
    endif()
  endforeach()

  # if(found_b)
  #     message(STATUS "found ${b}")
  # else()
  #     message(STATUS "not found ${b}")
  # endif()

  set(${OUTPUT_VAR} "${found_b}" PARENT_SCOPE)
endfunction()


# NOTE: currently only detect for CXX.
function(check_exist_debug_symbol)
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    string_find_element(${CMAKE_CXX_FLAGS_DEBUG} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE MATCHES "Release")
    string_find_element(${CMAKE_CXX_FLAGS_RELEASE} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
    string_find_element(${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
    string_find_element(${CMAKE_CXX_FLAGS_MINSIZEREL} -g exist_debug_symbol)
  elseif(CMAKE_BUILD_TYPE EQUAL "None" OR NOT CMAKE_BUILD_TYPE)
    string_find_element(${CMAKE_CXX_FLAGS} -g exist_debug_symbol)
  else()
    message(FATAL_ERROR "unsupported CMAKE_BUILD_TYPE for check_exist_debug_symbol: ${CMAKE_BUILD_TYPE}")
  endif()

  if(exist_debug_symbol)
    message(STATUS " exist debug symbo: YES")
  else()
    message(STATUS " exist debug symbo: NO")
  endif()
endfunction()


function(print_cxx_flags)
  message(STATUS ">>> CXX Flags:")
  message(STATUS ">>>   Current CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

  message(STATUS ">>>   CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_RELWITHDEBINFO: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>>   CMAKE_CXX_FLAGS_MINSIZEREL: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
endfunction()


function(print_c_flags)
  message(STATUS ">>> C Flags:")
  message(STATUS ">>>   Current CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

  message(STATUS ">>>   CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
  message(STATUS ">>>   CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
  message(STATUS ">>>   CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
  message(STATUS ">>>   CMAKE_C_FLAGS_RELWITHDEBINFO: ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>>   CMAKE_C_FLAGS_MINSIZEREL: ${CMAKE_C_FLAGS_MINSIZEREL}")
endfunction()


function(print_linker_flags)
  message(STATUS ">>> Linker Flags:")
  message(STATUS ">>>   Current CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

  message(STATUS ">>>   CMAKE_LINKER_FLAGS: ${CMAKE_LINKER_FLAGS}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_DEBUG: ${CMAKE_LINKER_FLAGS_DEBUG}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_RELEASE: ${CMAKE_LINKER_FLAGS_RELEASE}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_RELWITHDEBINFO: ${CMAKE_LINKER_FLAGS_RELWITHDEBINFO}")
  message(STATUS ">>>   CMAKE_LINKER_FLAGS_MINSIZEREL: ${CMAKE_LINKER_FLAGS_MINSIZEREL}")
endfunction()