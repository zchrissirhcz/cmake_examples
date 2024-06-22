#include <stdio.h>
#include <windows.h>

int main(int argc, char** argv)
{
    printf("hello world\n");

    printf("args:\n");
    for (int i = 0; i < argc; i++)
    {
        printf("%s ", argv[i]);
    }
    printf("\n");
    system("pause");
    return 0;
}
