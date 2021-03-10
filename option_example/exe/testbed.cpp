#include <stdio.h>

#ifdef USE_CAR
#include "car.h"
#endif

#ifdef USE_FACE
#include "face.h"
#endif

int main() {

#ifdef USE_CAR
    car_hello();
#endif

#ifdef USE_FACE
    face_hello();
#endif

    return 0;
}