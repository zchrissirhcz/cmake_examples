#include <boost/filesystem.hpp>
#include <iostream>

using namespace boost::filesystem;

int main()
{
    try
    {
        std::cout << absolute("photo.jpg", "D:\\") << '\n';
    }
    catch (filesystem_error& e)
    {
        std::cerr << e.what() << '\n';
    }
}