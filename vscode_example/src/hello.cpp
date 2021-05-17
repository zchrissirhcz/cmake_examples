#include <iostream>

class Range
{
public:
    Range(): start(0), end(0) {}
    Range(int _start, int _end): start(_start), end(_end) {}
    bool empty() const { return end==start; }
    Range operator+(const Range& r) {
        return Range(start+r.start, end+r.end);
    }

public:
    int start, end;
};

std::ostream& operator<<(std::ostream& os, const Range& range)
{
    return os << range.start << ", " << range.end;
}

int main()
{
    Range r1(1, 10);
    Range r2(5, 6);
    Range r3 = r1 + r2;
    int a = 3;
    int b = 4;
    int c  = 0;
    for(int i=0; i<10; i++) {
        c += a;
    }
    printf("c=%d\n", c);

    std::cout << r3 << std::endl;

    return 0;
}