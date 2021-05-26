#ifndef HELLO_H
#define HELLO_H

typedef unsigned char uchar;

#include <memory>

/// Matrix class
///
/// represens the image struct
///
class Mat
{
public:
    Mat(): rows_(0), cols_(0), data_(NULL){}

public:
    int rows();
    int cols();
    unsigned char* data();

private:
    int rows_;
    int cols_;
    std::shared_ptr<uchar> data_;
};

class Point
{
public:
    Point(): x(0), y(0) {}
    Point(int _x, int _y): x(_x), y(_y) {}

public:
    int x, y;
};

class Size
{
public:
    Size(): height(0), width(0) {}
    Size(int _height, int _width): height(_height), width(_width) {}

public:
    int height;
    int width;
};

#endif // HELLO_H