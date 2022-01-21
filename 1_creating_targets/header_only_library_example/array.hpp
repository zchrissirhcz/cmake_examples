#pragma once

#include <stdio.h>
#include <algorithm>
#include <iostream>

template<typename T>
class Array
{
public:
    Array(int _len);
    ~Array();
    Array(const Array& other);
    Array& operator=(const Array& other) = delete;

public:
    void fill(const T& value);

public:
    int len;
    T* data;
};

template<typename T>
Array<T> operator+(const Array<T>& a, const Array<T>& b)
{
    int len = std::min(a.len, b.len);
    Array<T> c(len);
    for (size_t i=0; i<len; i++)
    {
        c.data[i] = a.data[i] + b.data[i];
    }
    return c;
}


template<typename T>
Array<T>::Array(int _len):
    len(_len)
{
    data = new T[len];
}

template<typename T>
Array<T>::~Array()
{
    delete[] data;
}

template<typename T>
void Array<T>::fill(const T& value)
{
    for (size_t i=0; i<len; i++)
    {
        data[i] = value;
    }
}

template<typename T>
Array<T>::Array(const Array& other):
    Array(other.len)
{
    for (size_t i=0; i<len; i++)
    {
        data[i] = other.data[i];
    }
}

template<typename T>
std::ostream& operator<<(std::ostream& os, const Array<T>& arr)
{
    for (size_t i=0; i<arr.len; i++)
    {
        if (i>0) {
            os << ", ";
        }
        os << arr.data[i];
    }
    return os << std::endl;
}