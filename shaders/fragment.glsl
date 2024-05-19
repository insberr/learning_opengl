#version 330 core

in vec4 inColor;

out vec4 FragColor;

void main() {
    FragColor = inColor; // vec4(1.0, 0.5, 0.2, 1.0);
}
