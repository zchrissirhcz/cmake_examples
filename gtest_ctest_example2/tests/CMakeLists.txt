add_executable(testbed
    main.cpp
)

target_link_libraries(testbed GTest::gtest)

gtest_discover_tests(testbed) ##!! automatically let ctest scan
# then you can run `ctest` or `make test`
# for best practice, `ctest --output-on-failure` is what you need
