#include <stdio.h>
#include <string>
#include <opencv2/opencv.hpp>

void hello(const char* name)
{
    if (name)
    {
        printf("hello %s\n", name);
    }
    else
    {
        printf("hello world\n");
    }
}

class Point
{
public:
    int x, y;
    std::string name;

public:
    Point(): x(0), y(0), name("unknown") {}
    Point(int _x, int _y, const std::string _name): x(_x), y(_y), name(_name) {}
};

int main()
{
    int a = 3;
    int b = 4;
    int c = a + b;
    printf("c = %d\n", c);
    int d = c + 6;
    printf("d = %d\n", d);

    printf("a = %d\n", a);
    a ++;
    printf("a = %d\n", a);

    hello(NULL);
    hello("ChrisZZ");

    Point p1(a, b, "p1");
    Point p2(c, d, "p2");

    std::string name = "123";


#if __ANDROID__
    std::string load_prefix = "/data/local/tmp";
#elif __linux__
    std::string load_prefix = "/home/zz/data";
#elif _MSC_VER
    std::string load_prefix = "d:/data";
#else
#pragma error
#endif

    std::string filename = load_prefix + "/1920x1080.png";
    cv::Mat src = cv::imread(filename);
    cv::Mat gray;
    cv::cvtColor(src, gray, cv::COLOR_BGR2GRAY);

    printf("done\n");

    return 0;
}