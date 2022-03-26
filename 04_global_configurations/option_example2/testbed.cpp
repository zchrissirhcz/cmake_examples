#include <stdio.h>

int main(){
#ifdef USE_PLUGIN1
    printf("USE_PLUGIN1: YES\n");
#else
    printf("USE_PLUGIN1: NO\n");
#endif


#ifdef USE_PLUGIN2
    printf("USE_PLUGIN2: YES\n");
#else
    printf("USE_PLUGIN2: NO\n");
#endif


    return 0;
}
