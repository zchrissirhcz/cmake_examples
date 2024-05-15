#include "crc32c/crc32c.h"
#include <iostream>

static uint32_t swap_endian(uint32_t val) {
    val = ((val << 8) & 0xFF00FF00) | ((val >> 8) & 0xFF00FF);
    return (val << 16) | (val >> 16);
}

int main() {
    const std::uint8_t buffer[] = {0, 0, 0, 0};
    std::uint32_t result;

    // Process a raw buffer.
    result = crc32c::Crc32c(buffer, 4);

    // Process a std::string.
    std::string string;
    string.resize(4);
    result = crc32c::Crc32c(string);

    const uint8_t test_crc_input[] = { 0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0xDC,
        0x00, 0x00, 0x00, 0xDC, 0x10, 0x06, 0x00, 0x00, 0x00 };
    result = crc32c::Crc32c(test_crc_input, 17);
    printf("result is %lu\n", result);

    //unsigned char buf[4];
    //for (int i = 0; i < 4; i++) {
    //    buf[i] = (result >> (8 * i)) && 0xff;
    //}
    //printf("crc32c returns %lu, %lu, %lu, %lu\n", buf[0], buf[1], buf[2], buf[3]);


    return 0;
}