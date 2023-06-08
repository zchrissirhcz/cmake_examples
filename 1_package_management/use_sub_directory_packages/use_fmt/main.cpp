#include <fmt/core.h>
#include <iostream>

int main()
{
    fmt::print("Hello, world!\n");
    std::cout << fmt::format("hello, {:s}\n", "world");
    std::cout << fmt::format("PI is {:6.2f}\n", 3.1415926);

    return 0;
}
