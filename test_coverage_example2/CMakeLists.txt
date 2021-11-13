cmake_minimum_required(VERSION 3.20)
project(coverage_example)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include("deps.cmake")

add_library(arabicToRomanNumeralConveter
  ArabicToRomanNumeralConverter.hpp
  ArabicToRomanNumeralConverter.cpp
)

# coverage setting
set(coverage_compile_options -coverage -fprofile-arcs -ftest-coverage)
set(coverage_link_libraries -coverage -lgcov)

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set(GCOV_TOOL gcov)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(GCOV_TOOL ${CMAKE_SOURCE_DIR}/gcov_for_clang.sh)
endif()

target_compile_options(arabicToRomanNumeralConveter PUBLIC ${coverage_compile_options})
target_link_libraries(arabicToRomanNumeralConveter PUBLIC GTest::gtest ${coverage_link_libraries})

# test
add_executable(testbed testbed.cpp)
target_link_libraries(testbed arabicToRomanNumeralConveter)
enable_testing()
gtest_add_tests(TARGET testbed)

# coverage
add_custom_target(coverage
  COMMAND ctest --output-on-failure
  COMMAND lcov -d ./ -c -o lcov.info --gcov-tool ${GCOV_TOOL}
  COMMAND lcov -r lcov.info '/usr/*' -o lcov.info --gcov-tool ${GCOV_TOOL}
  COMMAND lcov -r lcov.info '*/build/*' -o lcov.info --gcov-tool ${GCOV_TOOL}
  COMMAND lcov --list lcov.info --gcov-tool ${GCOV_TOOL}
  COMMAND genhtml -o coverage_report lcov.info
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "View test coverage html report:"
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    cd coverage_report"
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    python -m http.server 7082"
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)