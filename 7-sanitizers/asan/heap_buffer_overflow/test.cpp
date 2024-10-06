#include <iostream>  

void heapBufferOverflowExample() {  
    // Dynamically allocate an array of 5 integers  
    int* buffer = new int[5];  

    // Intentionally access out-of-bounds index  
    for (int i = 0; i <= 5; ++i) { // Note the condition i <= 5  
        buffer[i] = i * 10;  
        std::cout << "Value at index " << i << ": " << buffer[i] << std::endl;  
    }  

    // Properly release the allocated memory  
    delete[] buffer;  
}  

int main() {  
    heapBufferOverflowExample();  

    // Other program logic  
    std::cout << "Program finished." << std::endl;  

    return 0;  
}
