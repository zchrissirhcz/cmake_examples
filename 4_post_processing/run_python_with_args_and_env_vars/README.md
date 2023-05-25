# Run Python from CMake, with 


# Run Python from CMake, with args and environment variables

## Introducntion
This example demonstrates 3 stuffs:
1. Run Python file via CMake
2. Passing arguments to Python, access it via `sys.argv`
3. Passing environment variable `TEST_FLAGS` to Python, access it via `os.getenv('TEST_FLAGS')`


This script run ok on both Linux and Windows.

## How to use
```bash
cmake -S . -B build
cmake -P start.cmake
```

Output:
```
  Running python script...
  Hello, CMake; Hello, Python
  sys.argv: ['D:/github/cmake_examples/4_post_processing/run_python_with_args_and_env_vars/testing/runtests.py', '--yes', '--nice']
  environ variable TEST_FLAGS:  "--xml"
```

## Explanation

### Passing arguments to Python
In `testing/CMakeLists.txt`, we call Python to run `testing/runtests.py`, with args `--yes --nice` specified:

```cmake
add_custom_target(tests
  COMMENT "Running python script..."
  COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/testing/runtests.py --yes --nice
)
```

### Passing environment variable to Python
In `start.cmake`, we call cmake command to execute the target `tests`, with environment variable `TEST_FLAGS` specified:

```cmake
execute_process(
  COMMAND
    ${CMAKE_COMMAND} -E env TEST_FLAGS="--xml" # This line specified environment variable, works on Windows and Linux
    cmake --build build --target tests
  RESULT_VARIABLE result
)
```