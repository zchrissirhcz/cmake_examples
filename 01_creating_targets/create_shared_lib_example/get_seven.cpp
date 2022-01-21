#include "get_seven.h"

int internal_do_calculation();

int PublicGetSeven() {
    return internal_do_calculation();
}

int internal_do_calculation() {
    return 7;
}