#include "hello.hpp"

int main()
{
    hello(nullptr);
    hello("cmake");

#if __ANDROID__
    hello("ANDROID");
#elif __linux__
    hello("Linux");
#elif _MSC_VER
    hello("Windows MSVC");
#endif

    return 0;
}

