#include <stdio.h>
#include "droid_HelloWorld.h"

JNIEXPORT void JNICALL Java_droid_HelloWorld_print
  (JNIEnv *env, jobject obj)
{
    printf("Hello World!\n");
    return;
}
