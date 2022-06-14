#include "MyImgui.h"

#include <iostream>

static void check_vk_result(VkResult err)
{
    if (err == 0)
        return;
    std::cout << "[MyImgui][Vulkan]"
              << " : VkResult = " << err << std::endl;
    if (err < 0)
        abort();
}

MyImgui::MyImgui(VulkanBase* base)
{
    vulkan = base;
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
}

MyImgui::~MyImgui()
{
    ImGui_ImplVulkan_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();

    vkDestroyDescriptorPool(vulkan->device, descriptorPool, vulkan->allocator);
}

void MyImgui::createDescriptorPool()
{
    VkResult err = VK_SUCCESS;
    VkDescriptorPoolSize pool_sizes[] =
        {
            {VK_DESCRIPTOR_TYPE_SAMPLER, 1000},
            {VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER, 1000},
            {VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE, 1000},
            {VK_DESCRIPTOR_TYPE_STORAGE_IMAGE, 1000},
            {VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER, 1000},
            {VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER, 1000},
            {VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER, 1000},
            {VK_DESCRIPTOR_TYPE_STORAGE_BUFFER, 1000},
            {VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC, 1000},
            {VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC, 1000},
            {VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT, 1000}};
    VkDescriptorPoolCreateInfo pool_info = {};

    pool_info.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
    pool_info.flags = VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT;
    pool_info.maxSets = 1000 * IM_ARRAYSIZE(pool_sizes);
    pool_info.poolSizeCount = (uint32_t)IM_ARRAYSIZE(pool_sizes);
    pool_info.pPoolSizes = pool_sizes;
    err = vkCreateDescriptorPool(vulkan->device, &pool_info, vulkan->allocator, &descriptorPool);
    check_vk_result(err);
}

void MyImgui::init()
{
    ImGuiIO& io = ImGui::GetIO();
    ImGui::StyleColorsDark();
}

void MyImgui::uploadFont()
{
    VkCommandBuffer command_buffer = vulkan->beginSingleTimeCommands();

    ImGui_ImplVulkan_CreateFontsTexture(command_buffer);

    vulkan->endSingleTimeCommands(command_buffer);

    ImGui_ImplVulkan_DestroyFontUploadObjects();
}

void MyImgui::initVulkanResource(VkRenderPass renderPass)
{
    ImGui_ImplVulkan_InitInfo init_info = {0};

    createDescriptorPool();

    ImGui_ImplGlfw_InitForVulkan(vulkan->pWindow.get(), true);

    init_info.Instance = vulkan->instance;
    init_info.PhysicalDevice = vulkan->physicalDevice;
    init_info.Device = vulkan->device;
    init_info.QueueFamily = vulkan->findQueueFamilies(vulkan->physicalDevice).graphicsFamily.value();
    init_info.Queue = vulkan->graphicsQueue;
    init_info.PipelineCache = nullptr;
    init_info.DescriptorPool = descriptorPool;
    init_info.Allocator = vulkan->allocator;
    init_info.MinImageCount = vulkan->minImageCount;
    init_info.ImageCount = vulkan->swapChainImageCount;
    init_info.CheckVkResultFn = check_vk_result;
    ImGui_ImplVulkan_Init(&init_info, renderPass);

    uploadFont();
}

void MyImgui::newFrame()
{
    ImGui_ImplVulkan_NewFrame();
    ImGui_ImplGlfw_NewFrame();
    ImGui::NewFrame();
}

void MyImgui::endNewFrame()
{
    ImGui::Render();
}

void MyImgui::drawFrame(VkCommandBuffer buffer)
{
    ImGui_ImplVulkan_RenderDrawData(ImGui::GetDrawData(), buffer);
}