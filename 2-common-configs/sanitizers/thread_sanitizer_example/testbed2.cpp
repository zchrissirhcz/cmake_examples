#include <pthread.h>
#include <stdio.h>
#include <mutex>

int Global;
std::mutex some_mutex;

void *Thread1(void *x) {
    {
        std::lock_guard<std::mutex> guard(some_mutex);
        Global++;
    }
    return NULL;
}

void *Thread2(void *x) {
    {
        std::lock_guard<std::mutex> guard(some_mutex);
        Global--;
    }
    return NULL;
}

int main() {
    pthread_t t[2];
    pthread_create(&t[0], NULL, Thread1, NULL);
    pthread_create(&t[1], NULL, Thread2, NULL);
    pthread_join(t[0], NULL);
    pthread_join(t[1], NULL);
}