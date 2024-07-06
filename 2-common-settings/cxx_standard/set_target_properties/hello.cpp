#include <iostream>
#include <tuple>

namespace ns1::ns2 {

std::tuple<int, int> func() {
    return {1, 2};
}

}

int main()
{
    auto [x, y] = ns1::ns2::func();
    std::cout << "x: " << x << ", y: " << y << std::endl;
}
