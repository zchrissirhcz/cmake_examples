cmake_minimum_required(VERSION 3.17)

project(hello)

option(BUILD_DOCS "build docs?" ON)

if(BUILD_DOCS)
    find_package(Doxygen REQUIRED)

    set(DOXYGEN_IN ${CMAKE_SOURCE_DIR}/docs/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT})

    # 注意这里的 `ALL` 参数是必须的：有了它，就可以用 cmake --build 生成文档，而不必手动执行 doxygen
    add_custom_target(doc ALL
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generate API documentations with Doxygen"
        VERBATIM
    )

    set(DOC_COVERAGE_DB ${CMAKE_CURRENT_BINARY_DIR}/doc-coverage.info)
    add_custom_target(doc_coverage ALL
        COMMAND rm -f ${DOC_COVERAGE_DB}
        COMMAND python -m coverxygen --xml-dir ${CMAKE_CURRENT_BINARY_DIR}/xml --src-dir ${CMAKE_SOURCE_DIR}/src --output ${DOC_COVERAGE_DB}
        COMMAND lcov -r ${DOC_COVERAGE_DB} '*/build/*' -o ${DOC_COVERAGE_DB}
        COMMAND lcov --summary ${DOC_COVERAGE_DB}
        COMMAND genhtml --no-function-coverage --no-branch-coverage ${DOC_COVERAGE_DB} -o doc_coverage_report

        COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "View doc coverage html report:"
        COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    cd doc_coverage_report"
        COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "    python -m http.server 7082"

        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generate doxygen document coverage report via lcov and coverxygen"
        VERBATIM
    )
endif()