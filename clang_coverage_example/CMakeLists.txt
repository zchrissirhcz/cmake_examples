cmake_minimum_required(VERSION 3.20)
project(hello)
add_executable(testbed foo.cc)
target_compile_options(testbed PUBLIC -fprofile-instr-generate -fcoverage-mapping)
target_link_libraries(testbed PUBLIC -fprofile-instr-generate)

set(EXEC_FILE testbed)

# run test and also generate coverage report
add_custom_target(coverage
    # Run the program
    COMMAND LLVM_PROFILE_FILE=foo.profraw ${EXEC_FILE}
    # Index the raw profile
    COMMAND llvm-profdata merge -sparse foo.profraw -o foo.profdata
    # Create a line-oriented coverage report.
    #COMMAND llvm-cov show ${EXEC_FILE} -instr-profile=foo.profdata --show-branches=count --show-expansions
    # Create a coverage summary, displayed in console
    COMMAND llvm-cov report ${EXEC_FILE} -instr-profile=foo.profdata
    # Create coverage report in a directory
    COMMAND llvm-cov show -format=html -instr-profile foo.profdata ${EXEC_FILE} -output-dir=coverage_report -Xdemangler c++filt -Xdemangler -n

    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "View test coverage html report:"
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    cd coverage_report"
    COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    python -m http.server 7082"
)