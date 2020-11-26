#include <stdio.h>

int main() {
    int len = 100;
    size_t buf_size = len * sizeof(int);

    int* data = (int*)my_alloc(buf_size);

    for (int i=0; i<len; i++) {
        data[i] = i;
    }

    return 0;
}
