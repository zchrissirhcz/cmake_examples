#include "bottle.h"
#include <iostream>
#include <string>

using namespace std;

int main(int argc, char** argv) {
    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
    int res = add(a, b);
    cout << "is " << res << endl;

    return 0;
}