#ifndef _IMGUI_H_
#define _IMGUI_H_

#include "VulkanBase.h"
#include "imgui.h"
#include "imgui_impl_glfw.h"
#include "imgui_impl_vulkan.h"

#include <vulkan/vulkan.h>

#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <memory>

class MyImgui {
public:
    MyImgui(VulkanBase* base);
    ~MyImgui();
    void init();
    void initVulkanResource(VkRenderPass renderPass);
    void newFrame();
    void endNewFrame();
    void drawFrame(VkCommandBuffer buffer);
    void showDemoWindow() { ImGui::ShowDemoWindow(); }

private:
    VkDescriptorPool descriptorPool;
    VulkanBase* vulkan;

    void createDescriptorPool();
    void uploadFont();
};

#endif