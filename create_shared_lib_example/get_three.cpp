#include "get_three.h"

int internal_do_calculation();

int PublicGetThree() {
	return internal_do_calculation();
}

int internal_do_calculation() {
	return 3;
}