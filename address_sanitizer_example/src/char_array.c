#include <stdio.h>
#include <string.h>

int main()
{
    // 字符串数组初始化，缺少\0
    char data[] = {'H', 'e', 'l', 'l', 'o'};

    // 正确写法
    //char data[] = {'H', 'e', 'l', 'l', 'o', '\0' };

    int length = strlen(data); // strlen的实现，依赖于对\0的判断，可能触发读取越界
    int size = sizeof(data);
    printf("--- data is %s\n", data);
    printf("strlen(data)=%d, sizeof(data)=%d\n", length, size);

    return 0;
}
