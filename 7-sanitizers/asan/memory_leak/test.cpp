#include <iostream>  

void memoryLeakExample() {  
    // Dynamically allocate an integer array  
    int* leakyArray = new int[10];  

    // Perform some operations on the array  
    for (int i = 0; i < 10; ++i) {  
        leakyArray[i] = i * 10;  
        std::cout << "Value at index " << i << ": " << leakyArray[i] << std::endl;  
    }  

    // Forget to release the allocated memory  
    // delete[] leakyArray; // This line is commented out, causing a memory leak  
}  

int main() {  
    memoryLeakExample();  

    // Other program logic  
    std::cout << "Program finished." << std::endl;  

    return 0;  
}
