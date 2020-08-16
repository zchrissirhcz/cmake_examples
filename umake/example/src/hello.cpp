#include "hello.h"

#include <stdio.h>

void hello(const char* name) {
    if(name==NULL) {
        printf("Hello, World!\n");
    } else {
        printf("Hello, %s\n", name);
    }
}
