cmake_minimum_required(VERSION 3.5)
project(hello C)

option(HELLO_INSTALL "install header file and lib files?" ON)
option(HELLO_EXPORT "export hello-config.cmake for find_package(hello)?" ON)

if(HELLO_INSTALL)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")
endif()

add_library(hello STATIC
  hello.c
)

if(HELLO_INSTALL)
  install(TARGETS hello 
    DESTINATION lib
    EXPORT hello
  )
  install(FILES hello.h DESTINATION include/hello)
  if(HELLO_EXPORT)
    install(EXPORT hello DESTINATION cmake/hello)
    include(CMakePackageConfigHelpers)
    set(CONFIG_CMAKE_IN "${CMAKE_BINARY_DIR}/Config.cmake.in")
    file(WRITE "${CONFIG_CMAKE_IN}" "@PACKAGE_INIT@\ninclude (\"\${CMAKE_CURRENT_LIST_DIR}/hello.cmake\")\n")
    configure_package_config_file(${CONFIG_CMAKE_IN} "${CMAKE_CURRENT_BINARY_DIR}/hello-config.cmake"
      INSTALL_DESTINATION cmake/hello
    )
    install(FILES
      ${CMAKE_CURRENT_BINARY_DIR}/hello-config.cmake
      DESTINATION cmake/hello
    )

    # 设置目标的包含目录
    include(CMakePackageConfigHelpers)
    target_include_directories(hello PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
      $<INSTALL_INTERFACE:include>
    )
  endif()
endif()