# find_package(Doxygen) is supported since cmake 3.9
# together with commands like doxygen_add_docs()
#

cmake_minimum_required(VERSION 3.17)

project(hello)

find_package(Doxygen REQUIRED)

if(DOXYGEN_FOUND)
    message(STATUS "DOXYGEN_VERSION: ${DOXYGEN_VERSION}")
endif()

set(DOXYGEN_GENERATE_HTML YES)
set(DOXYGEN_GENERATE_LATEX YES)
set(DOXYGEN_GENERATE_MAN NO)
set(DOXYGEN_GENERATO_XML NO)
doxygen_add_docs(my_docs
    ${CMAKE_SOURCE_DIR}
    COMMENT "Generate html and latex docs"
)



