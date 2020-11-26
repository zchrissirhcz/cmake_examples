#include <stdio.h>

void* my_alloc(size_t buf_size) {
    void* data = malloc(buf_size);
    return data;
}
