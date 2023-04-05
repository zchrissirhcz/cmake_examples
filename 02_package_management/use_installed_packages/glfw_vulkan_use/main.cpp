#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>//GLFW 库会自动包含Vulkan 库的头文件

#include <string.h>
#include <iostream>
#include <stdexcept>
#include <functional>//用于资源管理
#include <cstdlib>//用来使用 EXITSUCCESS 和 EXIT_FAILURE 宏
#include <set> //使用集合
#include <fstream>//读取文件

const int WIDTH = 800;
const int HEIGHT = 600;
//指定校验层的名称--代表隐式地开启所有可用的校验层
const std::vector<const char*> validataionLayers = {
    //"VK_LAYER_LUNARG_standard_validation"
    "VK_LAYER_KHRONOS_validation"
};
//控制是否启用指定的校验层
#ifdef NDEBUG
const bool enableValidationLayers = false;
#else
const bool enableValidationLayers = true;
#endif

class HelloTriangle{
public:
    void run(){
        initWindow();
        initVulkan();
        mainLoop();
        cleanup();
    }
private:
    GLFWwindow* window = nullptr;//窗口句柄
    VkInstance instance;//vulkan实例句柄
    VkDebugUtilsMessengerEXT callback;//存储回调函数信息
    ///初始化glfw
    void initWindow(){
        glfwInit();//初始化glfw库
        //显示阻止自动创建opengl上下文
        glfwWindowHint(GLFW_CLIENT_API,GLFW_NO_API);
        //禁止窗口大小改变
        glfwWindowHint(GLFW_RESIZABLE,GLFW_FALSE);
        /**
        glfwCreateWindow 函数:
        前三个参数指定了要创建的窗口的宽度，高度和标题.
        第四个参数用于指定在哪个显示器上打开窗口,
        最后一个参数与 OpenGL 相关
          */
        //创建窗口
        window = glfwCreateWindow(WIDTH,HEIGHT,"vulakn",
                                  nullptr,nullptr);
    }
    void createInstance(){
        //是否启用校验层并检测指定的校验层是否支持
        if(enableValidationLayers && !checkValidationLayerSupport()){
            throw std::runtime_error(
                        "validation layers requested,but not available");
        }
        /**
        VkApplicationInfo设置写应用程序信息，这些信息的填写不是必须的，但填写的信息
        可能会作为驱动程序的优化依据，让驱动程序进行一些特殊的优化。比如，应用程序使用了
        某个引擎，驱动程序对这个引擎有一些特殊处理，这时就可能有很大的优化提升。
          */
        /**
          Vulkan 创建对象的一般形式如下:
            sType 成员变量来显式指定结构体类型
            pNext 成员可以指向一个未来可能扩展的参数信息--这个教程里不使用
          */
        VkApplicationInfo appinfo={};
        appinfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
        appinfo.pApplicationName = "hello";
        appinfo.applicationVersion = VK_MAKE_VERSION(1,1,77);
        appinfo.pEngineName = "No Engine";
        appinfo.engineVersion = VK_MAKE_VERSION(1,1,77);
        appinfo.apiVersion = VK_API_VERSION_1_1;

        /**
        VkInstanceCreateInfo告诉Vulkan的驱动程序需要使用的全局扩展和校验层
        全局是指这里的设置对于整个应用程序都有效，而不仅仅对一个设备有效
          */
        //设置vulkan实例信息
        VkInstanceCreateInfo createInfo = {};
        createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
        createInfo.pApplicationInfo = &appinfo;
        /**
          返回支持的扩展列表:
            我们可以获取扩展的个数，以及扩展的详细信息
        */
        uint32_t extensionCount = 0;//扩展的个数
        vkEnumerateInstanceExtensionProperties(nullptr,
                                             &extensionCount,nullptr);
        //分配数组来存储扩展信息
        //每个 VkExtensionProperties 结构体包含了扩展的名字和版本信息
        std::vector<VkExtensionProperties> extensions(extensionCount);
        //获取所有扩展信息
        vkEnumerateInstanceExtensionProperties(nullptr,
                                               &extensionCount,
                                               extensions.data());
        std::cout << "available extension:" << std::endl;
        for(const auto& extension : extensions){
            std::cout << "\t"<<extension.extensionName<<std::endl;
        }

        //设置扩展列表
        auto extensions2 = getRequiredExtensions();
        createInfo.enabledExtensionCount =
                static_cast<uint32_t>(extensions2.size());
        createInfo.ppEnabledExtensionNames = extensions2.data();

        //判断是否启用校验层,如果启用则设置校验层信息
        if(enableValidationLayers){
            //设置layer信息
            createInfo.enabledLayerCount =
                    static_cast<uint32_t>(validataionLayers.size());
            createInfo.ppEnabledLayerNames = validataionLayers.data();
        }else{

            createInfo.enabledLayerCount = 0;
        }
        /**
          创建 Vulkan 对象的函数参数的一般形式如下：
          1.一个包含了创建信息的结构体指针
          2.一个自定义的分配器回调函数，本教程未使用，设置为nullptr
          3.一个指向新对象句柄存储位置的指针
          */
        //创建vulkan实例
        VkResult result = vkCreateInstance(&createInfo,nullptr,
                                           &instance);
        if(result != VK_SUCCESS){
            throw std::runtime_error("failed to create instance!");
        }
    }
    //使用代理函数创建VkDebugUtilsMessengerEXT
    VkResult CreateDebugUtilsMessengerEXT(VkInstance instance ,
             const VkDebugUtilsMessengerCreateInfoEXT* pCreateInfo,
             const VkAllocationCallbacks * pAllocator,
             VkDebugUtilsMessengerEXT* pCallback){
        /**
        vkCreateDebugUtilsMessengerEXT 函数是一个扩展函数，不会被Vulkan库
        自动加载，所以需要我们自己使用 vkGetInstanceProcAddr 函数来加载它

        函数的第二个参数是可选的分配器回调函数，我们没有自定义的分配器，
        所以将其设置为 nullptr。由于我们的调试回调是针对特定Vulkan实例和它的校验层，
        所以需要在第一个参数指定调试回调作用的 Vulkan 实例。
          */
        auto func = (PFN_vkCreateDebugUtilsMessengerEXT)vkGetInstanceProcAddr(
                    instance,"vkCreateDebugUtilsMessengerEXT");
        if ( func != nullptr ){
            //使用代理函数来创建扩展对象
            return func(instance,pCreateInfo,pAllocator,pCallback);
        }else{
            return VK_ERROR_EXTENSION_NOT_PRESENT;
        }
    }
    //创建代理函数销毁VkDebugUtilsMessengerEXT
    void DestroyDebugUtilsMessengerEXT(VkInstance instance ,
                                VkDebugUtilsMessengerEXT callback,
                                const VkAllocationCallbacks* pAllocator){
        auto func = (PFN_vkDestroyDebugUtilsMessengerEXT)vkGetInstanceProcAddr(
                    instance,"vkDestroyDebugUtilsMessengerEXT");
        if ( func != nullptr ){
            return func(instance,callback,pAllocator);
        }
    }
    //设置调试回调
    void setupDebugCallback(){
        //如果未启用校验层直接返回
        if(!enableValidationLayers)
            return;
        //设置调试结构体所需的信息
        VkDebugUtilsMessengerCreateInfoEXT createInfo = {};
        createInfo.sType =
        VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
        //用来指定回调函数处理的消息级别
        createInfo.messageSeverity =
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT |
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT |
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
        //指定回调函数处理的消息类型
        createInfo.messageType =
        VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT |
        VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT |
        VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;
        //指向回调函数的指针
        createInfo.pfnUserCallback = debugCallback ;
        //指向用户自定义数据的指针它是可选的
        //这个指针所指的地址会被作为回调函数的参数，用来向回调函数传递用户数据
        createInfo.pUserData = nullptr ; // Optional
        //使用代理函数创建 VkDebugUtilsMessengerEXT 对象
        if(CreateDebugUtilsMessengerEXT(instance,&createInfo,
                      nullptr,&callback) != VK_SUCCESS){
            throw std::runtime_error("faild to set up debug callback!");
        }
    }
    //初始化 Vulkan 对象。
    void initVulkan(){
        createInstance();//创建vulkan实例
        setupDebugCallback();//调试回调
    }
    //设置主循环
    void mainLoop(){
        //添加事件循环
        //glfwWindowShouldClose检测窗口是否关闭
        while(!glfwWindowShouldClose(window)){
            glfwSwapBuffers(window);
            glfwPollEvents();//执行事件处理
        }
    }
    //清理资源
    void cleanup(){
        if(enableValidationLayers){
            //调用代理销毁VkDebugUtilsMessengerEXT对象
            DestroyDebugUtilsMessengerEXT(instance,callback,nullptr);
        }
        /**
        Vulkan 中创建和销毁对象的函数都有一个 VkAllocationCallbacks 参数,
        可以被用来自定义内存分配器,本教程也不使用
         */
        //销毁vulkan实例
        vkDestroyInstance(instance,nullptr);
        //销毁窗口
        glfwDestroyWindow(window);
        //结束glfw
        glfwTerminate();
    }
    //请求所有可用的校验层
    bool checkValidationLayerSupport(){
        //vkEnumerateInstanceLayerProperties获取了所有可用的校验层列
        uint32_t layerCount;
        vkEnumerateInstanceLayerProperties(&layerCount,nullptr);
        std::vector<VkLayerProperties> availableLayers(layerCount);
        vkEnumerateInstanceLayerProperties(&layerCount,
                                           availableLayers.data());
        for(const char* layerName : validataionLayers){
            bool layerFound = false;
            for(const auto& layerProperties : availableLayers){
                std::cout << "layername:"<<layerProperties.layerName<<std::endl;
                if(strcmp(layerName,layerProperties.layerName)==0){
                    layerFound = true;
                    break;
                }
            }
            if(!layerFound){
                return false;
            }
        }
        return true;
    }
    //根据是否启用校验层，返回所需的扩展列表
    std::vector<const char*> getRequiredExtensions(){
        uint32_t glfwExtensionCount =0;
        const char** glfwExtensions;
        glfwExtensions=glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

        std::vector<const char*> extensions(glfwExtensions,
                                            glfwExtensions+glfwExtensionCount);
        if(enableValidationLayers){
            //需要使用 VK_EXT_debug_utils 扩展，设置回调函数来接受调试信息
            //如果启用校验层,添加调试报告相关的扩展
            extensions.push_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
        }
        return extensions;
    }
    /**
      第一个参--指定了消息的级别，可以使用比较运算符来过滤处理一定级别以上的调试信息
    它可以是下面的值：
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT：诊断信息
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT：资源创建之类的信息
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT：警告信息
    VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT：不合法和可能造成崩溃的操作信息

    第二个参数--消息的类型，如下：
    VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT：
    发生了一些与规范和性能无关的事件
    VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT：
    出现了违反规范的情况或发生了一个可能的错误
    VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT：
    进行了可能影响 Vulkan 性能的行为

    第三个参--一个指向 VkDebugUtilsMessengerCallbackDataEXT 结构体的指针
    包含了下面这些非常重要的成员：
    pMessage：一个以 null 结尾的包含调试信息的字符串
    pObjects：存储有和消息相关的 Vulkan 对象句柄的数组
    objectCount：数组中的对象个数

    最后一个参数 pUserData 是一个指向了我们设置回调函数时，传递的数据的指针

    回调函数返回了一个布尔值，用来表示引发校验层处理的 Vulkan API调用是否被中断。
    如果返回值为 true，对应 Vulkan API 调用就会返回
    VK_ERROR_VALIDATION_FAILED_EXT 错误代码。
    通常，只在测试校验层本身时会返回 true，其余情况下，回调函数应该返回 VK_FALSE
      */
    //接受调试信息的回调函数,以 vkDebugUtilsMessengerCallbackEXT 为原型
    //使用 VKAPI_ATTR 和 VKAPI_CALL 定义，确保它可以被 Vulkan 库调用
    static VKAPI_ATTR VkBool32 VKAPI_CALL debugCallback(
            VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
            VkDebugUtilsMessageTypeFlagsEXT messageType,
            const VkDebugUtilsMessengerCallbackDataEXT* pCallbackData,
            void* pUserData){
        std::cerr<<"validation layer: "<<pCallbackData->pMessage<<std::endl;
        return VK_FALSE;
    }
};
int main(int argc, char *argv[])
{
    HelloTriangle hello;
    try{
        hello.run();
    }catch(const std::exception& e){
        //捕获并打印hello中抛出的异常
        std::cerr<<e.what()<<std::endl;
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
