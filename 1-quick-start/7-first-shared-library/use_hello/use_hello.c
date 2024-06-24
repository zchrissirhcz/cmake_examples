#include <hello/hello.h>

int main()
{
    hello_init();
    hello_run("World");
    hello_run("CMake");
    hello_destroy();
    return 0;
}
