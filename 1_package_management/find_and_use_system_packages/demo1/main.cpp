// 创建线程，并等待线程执行结束。
// 检查了线程创建、等待线程结束时的返回值。

#include <pthread.h>
#include <stdio.h>

void* func(void* arg)
{
    printf("Thread created\n");

    return NULL;
}

int main()
{
    pthread_t thread;
    int ret = pthread_create(&thread, NULL, func, NULL);
    if (ret != 0)
    {
        printf("pthread_create() failed, return %d\n", ret);
        return ret;
    }

    ret = pthread_join(thread, NULL);
    if (ret != 0)
    {
        printf("pthread_join() failed, return %d\n", ret);
        return ret;
    }

    return 0;
}