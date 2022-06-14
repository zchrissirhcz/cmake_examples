#ifndef _VULKAN_APP_H_
#define _VULKAN_APP_H_

#include "MyImgui.h"
#include "VulkanBase.h"

#include <array>
#include <cstdlib>
#include <glm/glm.hpp>
#include <memory>
#include <optional>
#include <vector>
#include <vulkan/vulkan.h>
#include <string>

constexpr int32_t WIDTH = 512;
constexpr int32_t HEIGHT = 512;

struct UniformBufferObject {
    glm::mat4 model;
    glm::mat4 view;
    glm::mat4 proj;
};

struct Vertex {
    glm::vec2 pos;
    glm::vec3 color;
    glm::vec2 texCoord;

    static VkVertexInputBindingDescription getBindingDescription()
    {
        VkVertexInputBindingDescription bindingDescription{};
        bindingDescription.binding = 0;
        bindingDescription.stride = sizeof(Vertex);
        bindingDescription.inputRate = VK_VERTEX_INPUT_RATE_VERTEX;

        return bindingDescription;
    }

    static std::array<VkVertexInputAttributeDescription, 3> getAttributeDescriptions()
    {
        std::array<VkVertexInputAttributeDescription, 3> attributeDescriptions{};

        //pos
        attributeDescriptions[0].binding = 0;
        attributeDescriptions[0].location = 0;
        attributeDescriptions[0].format = VK_FORMAT_R32G32_SFLOAT;
        attributeDescriptions[0].offset = offsetof(Vertex, pos);

        attributeDescriptions[1].binding = 0;
        attributeDescriptions[1].location = 1;
        attributeDescriptions[1].format = VK_FORMAT_R32G32B32_SFLOAT;
        attributeDescriptions[1].offset = offsetof(Vertex, color);

        attributeDescriptions[2].binding = 0;
        attributeDescriptions[2].location = 2;
        attributeDescriptions[2].format = VK_FORMAT_R32G32_SFLOAT;
        attributeDescriptions[2].offset = offsetof(Vertex, texCoord);

        return attributeDescriptions;
    }
};

struct FrameBufferAttachment {
    VkImage image;
    VkDeviceMemory mem;
    VkImageView view;
};

struct OffscreenPass {
    int32_t width, height;
    VkFramebuffer frameBuffer;
    FrameBufferAttachment color, depth;
    VkRenderPass renderPass;
    VkSampler sampler;
    VkDescriptorImageInfo descriptor;
    VkPipeline pipeline;
};

const std::vector<uint16_t> indices = {0, 1, 2, 2, 3, 0};

const std::vector<Vertex> vertices = {
    {{-0.5f, -0.5f}, {1.0f, 0.0f, 0.0f}, {0.0f, 0.0f}},
    {{0.5f, -0.5f}, {0.0f, 1.0f, 0.0f}, {1.0f, 0.0f}},
    {{0.5f, 0.5f}, {0.0f, 0.0f, 1.0f}, {1.0f, 1.0f}},
    {{-0.5f, 0.5f}, {1.0f, 1.0f, 1.0f}, {0.0f, 1.0f}}};

class VulkanApp : public VulkanBase {
public:
    VulkanApp(uint32_t width,
              uint32_t height,
              const std::string title,
              bool enableValidationLayers) :
        VulkanBase(width, height, title, enableValidationLayers) {}
    ~VulkanApp();
    void run();
    void prepare();


private:
    VkDescriptorSetLayout descriptorSetLayout;
    VkPipelineLayout pipelineLayout;
    VkPipeline graphicsPipeline;
    VkBuffer vertexBuffer;
    VkDeviceMemory vertexBufferMemory;
    VkBuffer indexBuffer;
    VkDeviceMemory indexBufferMemory;
    VkBuffer uniformBuffers;
    VkDeviceMemory uniformBuffersMemory;
    VkDescriptorPool descriptorPool;
    VkDescriptorSet descriptorSets;
    VkImage textureImage;
    VkDeviceMemory textureImageMemory;
    VkImageView textureImageView;
    VkSampler textureSampler;
    std::unique_ptr<MyImgui> imgui;
    ImTextureID myTextureId;
    struct OffscreenPass offscreenPass;
    bool show_demo_window = true;
    bool show_another_window = true;
    ImVec2 textureWindowSize;

    VkShaderModule createShaderModule(const std::vector<char>& code);
    void drawFrame();
    void createVertexBuffer();
    void createIndexBuffer();
    void createDescriptorSetLayout();
    void createUniformBuffers();
    void updateUniformBuffer();
    void createDescriptorSets();
    void createTextureImage();
    void createTextureImageView();
    void createTextureSampler();
    void createDescriptorPool();
    void handleWindowResize();
    void prepareImgui();
    void buildCommandBuffer(uint32_t index);
    void drawImguiObjects();

    // offsscreen
    void prepareOffscreen();
    void createOffscreensRenderPass();
    void createOffscreenImage();
    void createOffscreenImageView();
    void createOffscreenFramebuffer();
    void createOffscreenPipeline();
};

#endif
