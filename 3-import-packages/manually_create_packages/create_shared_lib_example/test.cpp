#include <stdio.h>

#include "get_three.h"
#include "get_seven.h"

int main() {
    printf("PublicGetThree returned %d\n", PublicGetThree());
    printf("PublicGetSeven returned %d\n", PublicGetSeven());
}