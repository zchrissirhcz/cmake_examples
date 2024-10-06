#include <CL/cl.h>  
#include <iostream>  
#include <vector>  
#include <string>  

std::string getPlatformInfo(cl_platform_id platform, cl_platform_info param) {  
    size_t size;  
    clGetPlatformInfo(platform, param, 0, nullptr, &size);  
    std::string result(size, '\0');  
    clGetPlatformInfo(platform, param, size, &result[0], nullptr);  
    return result;  
}  

std::string getDeviceInfo(cl_device_id device, cl_device_info param) {  
    size_t size;  
    clGetDeviceInfo(device, param, 0, nullptr, &size);  
    std::string result(size, '\0');  
    clGetDeviceInfo(device, param, size, &result[0], nullptr);  
    return result;  
}  

int main() {  
    // 1. 获取平台  
    cl_uint platformCount;  
    clGetPlatformIDs(0, nullptr, &platformCount);  
    std::vector<cl_platform_id> platforms(platformCount);  
    clGetPlatformIDs(platformCount, platforms.data(), nullptr);  

    if (platforms.empty()) {  
        std::cerr << "No OpenCL platforms found." << std::endl;  
        return 1;  
    }  

    for (const auto& platform : platforms) {  
        std::cout << "Platform: " << getPlatformInfo(platform, CL_PLATFORM_NAME) << std::endl;  

        // 2. 获取设备  
        cl_uint deviceCount;  
        clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, 0, nullptr, &deviceCount);  
        std::vector<cl_device_id> devices(deviceCount);  
        clGetDeviceIDs(platform, CL_DEVICE_TYPE_ALL, deviceCount, devices.data(), nullptr);  

        if (devices.empty()) {  
            std::cerr << "No OpenCL devices found on this platform." << std::endl;  
            continue;  
        }  

        for (const auto& device : devices) {  
            std::cout << "  Device: " << getDeviceInfo(device, CL_DEVICE_NAME) << std::endl;  
        }  

        // 创建上下文，第3个参数为device而非platform  
        cl_int err;  
        cl_context context = clCreateContext(nullptr, deviceCount, devices.data(), nullptr, nullptr, &err);  
        if (err != CL_SUCCESS) {  
            std::cerr << "Failed to create OpenCL context." << std::endl;  
            return 1;  
        }  

        // 4. 创建命令队列  
        cl_command_queue commandQueue = clCreateCommandQueue(context, devices[0], 0, &err);  
        if (err != CL_SUCCESS) {  
            std::cerr << "Failed to create command queue." << std::endl;  
            clReleaseContext(context);  
            return 1;  
        }  

        std::cout << "OpenCL initialization successful." << std::endl;  

        // 清理资源  
        clReleaseCommandQueue(commandQueue);  
        clReleaseContext(context);  
    }  

    return 0;  
}
