set(ENV{CTEST_OUTPUT_ON_FAILURE} "ON")

# not working on windows: does not recognize env var TEST_FLAGS
# execute_process(
#   COMMAND cmake --build build --target tests TEST_FLAGS="--xml"
#   RESULT_VARIABLE result
# )

execute_process(
  COMMAND
    ${CMAKE_COMMAND} -E env TEST_FLAGS="--xml"
    cmake --build build --target tests
  RESULT_VARIABLE result
)

if (NOT result EQUAL 0)
  message(FATAL_ERROR "Running tests failed!")
endif()