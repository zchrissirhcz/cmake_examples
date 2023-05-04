#include <fmt/core.h>


int main()
{
    fmt::print("Hello, world!\n");
    fmt::format("hello, {:s}", "world");

    return 0;
}
