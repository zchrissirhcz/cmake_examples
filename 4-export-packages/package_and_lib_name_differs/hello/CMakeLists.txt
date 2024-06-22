cmake_minimum_required(VERSION 3.5)
project(hello C)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")
add_library(hello STATIC hello.c)

set(NAME "hulu") # package name. you should use find_package(hulu REQUIRED) in other projects
set(LIBS hello) # a list of targets to be installed
set(LIB_DIR "lib")
set(INC_DIR "inc")
set(INCS hello.h)

install(FILES ${INCS} DESTINATION ${INC_DIR}/${NAME})
install(TARGETS ${LIBS}
  EXPORT ${NAME}
  DESTINATION ${LIB_DIR}
  INCLUDES DESTINATION ${INC_DIR}
)
install(EXPORT ${NAME}
  DESTINATION cmake
  NAMESPACE ${NAME}::
  FILE ${NAME}-config.cmake
)