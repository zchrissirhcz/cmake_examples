Create a package "hulu" which actually holds the header files and library files of the `hello` target.
The create package is "hulu", which contains a target `hulu::hello`. `hulu::` is the namespace.

User should use `hulu_DIR` and `find_package(hulu REQUIRED)`, and link `hulu::hello` target.

In source files, use `#include <hulu/hello.h>`.