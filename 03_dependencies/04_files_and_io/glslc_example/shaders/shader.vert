#version 450

layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec2 inTexCoord;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexCoord;

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

void main() {
    // directly output normalized device coordinates 
    // by outputting them as clip coordinates from the vertex shader 
    // with the last component set to 1. 
    // he built-in variable gl_Position functions as the output
    // gl_Position = vec4(inPosition, 0.0, 1.0);
    // fragColor = inColor;

    gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition, 0.0, 1.0);
    fragColor = inColor;
    fragTexCoord = inTexCoord;
}
