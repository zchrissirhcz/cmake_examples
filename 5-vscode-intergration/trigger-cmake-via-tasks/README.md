# Trigger CMake via Tasks

The CMake Tools extension is nearly out-of-the-box for simple C/C++ projects.

When we want passing command line arguments for "CMake: Configure", or, the cmake configure is trigggered via Python/CMake script mode, `tasks.json` is for that.

The `tasks.json` is ready, just use it by choosing tasks in Command Palette:

1. `>Tasks: Run Task`, choose `cmake-configure`

2. `>Developer: Reload Window`: this is for C/C++ IntelliSense Restart.

3. `>Tasks: Run Task`, choose `cmake-build`

4. `>Tasks: Run Task`, choose `Run hello`