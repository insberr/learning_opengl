#version 330 core

layout(location = 0) in vec3 aPos;
out vec4 inColor;

void main() {
    gl_Position = vec4(aPos, 1.0);
    inColor = vec4(aPos, 1.0);
}
