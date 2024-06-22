# first-package

Create an installable library "hello":
- Build the static library file
- Install library file
- Install header file
- Generate and install export files (`hello-config.cmake`) for user's `find_package()` usage purpose
- Automatically setup include directories for user of find_package()

Create and executable "use_hello":
- Set hello_DIR to the previous installed hello's cmake export directory
- find_package(hello REQUIRED)
- Create executable target and link hello on it
    - the header files can be found correctly, painlessly
    - the library files can be correctly linked to this target
