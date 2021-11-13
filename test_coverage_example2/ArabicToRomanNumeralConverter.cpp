#include "ArabicToRomanNumeralConverter.hpp"
#include <array>

const std::size_t numberOfMappings = 13;
using ArabicToRomanMappings = std::array<ArabicToRomanMapping, numberOfMappings>;

const ArabicToRomanMappings arabicToRomanMappings = { {
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
} };


std::string convertArabicNumberToRomanNumeral(unsigned int arabicNumber)
{
    std::string romanNumeral;
    for (const auto& mapping: arabicToRomanMappings)
    {
        while (arabicNumber >= mapping.arabicNumber)
        {
            romanNumeral += mapping.romanNumeral;
            arabicNumber -= mapping.arabicNumber;
        }
    }
    return romanNumeral;
}