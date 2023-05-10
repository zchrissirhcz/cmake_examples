#pragma once

#include <string>

struct ArabicToRomanMapping
{
    unsigned int arabicNumber;
    std::string romanNumeral;
};

std::string convertArabicNumberToRomanNumeral(unsigned int arabicNumber);