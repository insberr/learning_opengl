#version 330 core

out vec4 FragColor;
in vec3 fragCoord;

uniform vec2 Resolution;
uniform float Time;
uniform vec2 Mouse;

// 2D Rotation Function
mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

// Function to calculate distance from a point to a sphere
float sphereSDF(vec3 point, vec3 center, float radius) {
    return length(point - center) - radius;
}

float cubeSDF(vec3 point, vec3 size) {
    vec3 q = abs(point) - size;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

const int MAX_STEPS = 100;
const float MAX_DISTANCE = 100.0;
// The distance to an object that is considered a hit
const float SURFACE_DIST = 0.001;
// FOV constant
const float FOV = 1.0;
const float MOUSE_SENSITIVITY = 4.0;

float scene(vec3 p) {
    vec3 spherePos = vec3(sin(Time) * 3.0, 0, 0.0);
    float sphere = sphereSDF(p, spherePos, 1.0);

    vec3 q = fract(p) - .5;
    float cube = cubeSDF(q, vec3(.1));

    float ground = p.y + .75;
    if (ground < -0.001) {
        ground = abs(ground);
    }

    return min(ground, min(sphere, cube));
}

// The ray marching magic happens here
vec4 rayMarch(vec3 ro, vec3 rd) {
    float totalDistance = 0.0;
    vec3 color = vec3(0.0);

    for (int i = 0; i < MAX_STEPS; ++i) {
        vec3 p = ro + rd * totalDistance;

        float d = scene(p);

        totalDistance += d;

        // Color based on iteration count
        // color = vec3(i) / MAX_STEPS;

        if (d < SURFACE_DIST || totalDistance > MAX_DISTANCE) break;
    }

    // Color based on depth
    color = vec3(totalDistance * .2);

    return vec4(color, 1.0);

//    if (totalDistance > MAX_DISTANCE) {
//        return vec4(0.0);
//    } else {
//            return vec4(0.7);
//    }

    // return vec4(0.0);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2. - Resolution.xy) / Resolution.y; //  (2.0 * gl_FragCoord.xy - Resolution) / min(Resolution.x, Resolution.y); // fragCoord.xy / Resolution * 2.0 - 1.0;
    // uv.x *= Resolution.x / Resolution.y;
    vec2 mouse = (Mouse.xy * 2. - Resolution.xy) / Resolution.y * MOUSE_SENSITIVITY;

    vec3 rayOrigin = vec3(0.0, 0.0, -3.0);
    vec3 rayDirection = normalize(vec3(uv * FOV, 1.0));

    // Vertical camera movement
    rayOrigin.yz *= rot2D(-mouse.y);
    rayDirection.yz *= rot2D(-mouse.y);

    // Horizontal camera movement
    rayOrigin.xz *= rot2D(-mouse.x);
    rayDirection.xz *= rot2D(-mouse.x);

    vec4 color = rayMarch(rayOrigin, rayDirection);

    FragColor = color; // vec4(fragCoord, 1.0); // vec4(1.0, 0.5, 0.2, 1.0);
}
