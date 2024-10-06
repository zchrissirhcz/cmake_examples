#include <iostream>  
#include <thread>  
#include <chrono>  

void threadFunction() {  
    std::this_thread::sleep_for(std::chrono::seconds(1));  
    std::cout << "Thread finished work" << std::endl;  
}  

int main() {  
    std::thread t(threadFunction);  

    // 演示线程泄漏：没有调用 join() 或 detach()  
    // t.join();  

    std::cout << "Main function finished" << std::endl;  
    return 0;  
}
