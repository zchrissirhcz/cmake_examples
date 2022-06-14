#version 450
#extension GL_ARB_separate_shader_objects : enable

// You have to specify your own output variable for each framebuffer 
// where the layout(location = 0) modifier specifies the index of the framebuffer. 
// The color red is written to this outColor variable that is linked to the first (and only) framebuffer at index 0
layout(location = 0) out vec4 outColor;
layout(location = 1) in vec2 fragTexCoord;

layout(location = 0) in vec3 fragColor;

layout(binding = 1) uniform sampler2D texSampler;

void main() {
    // A simple fragment shader that outputs the color red for the entire triangle.
    // The color red is written to this outColor variable 
    // that is linked to the first (and only) framebuffer at index 0.
    // outColor = vec4(1.0, 0.0, 0.0, 1.0);

    // The input variable does not necessarily have to use the same name, 
    // they will be linked together using the indexes specified by the location directives. 
    outColor = texture(texSampler, fragTexCoord);
}
