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