cmake_minimum_required(VERSION 3.20)
project(coverage_example)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include("deps.cmake")

add_library(arabicToRomanNumeralConveter
  ArabicToRomanNumeralConverter.hpp
  ArabicToRomanNumeralConverter.cpp
)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(coverage_compile_options -fprofile-instr-generate -fcoverage-mapping)
  set(coverage_link_libraries -fprofile-instr-generate)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set(coverage_compile_options -coverage -fprofile-arcs -ftest-coverage)
  set(coverage_link_libraries -coverage -lgcov)
endif()

target_compile_options(arabicToRomanNumeralConveter PUBLIC ${coverage_compile_options})
target_link_libraries(arabicToRomanNumeralConveter PUBLIC GTest::gtest ${coverage_link_libraries})

# test
add_executable(testbed testbed.cpp)
target_link_libraries(testbed arabicToRomanNumeralConveter)
enable_testing()
gtest_add_tests(TARGET testbed)

# coverage
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(EXEC_FILE ./testbed)
  add_custom_target(coverage
    COMMAND LLVM_PROFILE_FILE=foo.profraw ctest --output-on-failure
    COMMAND llvm-profdata merge -sparse foo.profraw -o foo.profdata
    #COMMAND llvm-cov show ${EXEC_FILE} -instr-profile=foo.profdata --show-branches=count --show-expansions
    COMMAND llvm-cov report ${EXEC_FILE} -instr-profile=foo.profdata
    COMMAND llvm-cov show -format=html -instr-profile foo.profdata ${EXEC_FILE} -output-dir=coverage_report -Xdemangler c++filt -Xdemangler -n -use-color
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "View test coverage html report:"
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    cd coverage_report"
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    python -m http.server 7082"
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  add_custom_target(coverage
    COMMAND ctest --output-on-failure
    COMMAND lcov -d ./ -c -o lcov.info
    COMMAND lcov -r lcov.info '/usr/*' -o lcov.info
    COMMAND lcov -r lcov.info '*/build/*' -o lcov.info
    COMMAND lcov --list lcov.info
    COMMAND genhtml -o coverage_report lcov.info
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "View test coverage html report:"
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    cd coverage_report"
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    python -m http.server 7082"
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
endif()