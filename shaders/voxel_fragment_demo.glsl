#version 330 core

// Code from https://www.shadertoy.com/view/4dX3zl
// And modified by me

//The raycasting code is somewhat based around a 2D raycasting toutorial found here:
//http://lodev.org/cgtutor/raycasting.html

const bool USE_BRANCHLESS_DDA = true;
const int MAX_RAY_STEPS = 64;

float sdSphere(vec3 p, float d) { return length(p) - d; }

float sdBox( vec3 p, vec3 b )
{
    vec3 d = abs(p) - b;
    return min(max(d.x,max(d.y,d.z)),0.0) +
    length(max(d,0.0));
}

// test if a voxel exists here
bool getVoxel(ivec3 c) {
    vec3 p = vec3(c) + vec3(0.5);
    float d = sdSphere(p, 5.0);
    return d < 0.0;
}

vec2 rotate2d(vec2 v, float a) {
    float sinA = sin(a);
    float cosA = cos(a);
    return vec2(v.x * cosA - v.y * sinA, v.y * cosA + v.x * sinA);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 screenPos = (fragCoord.xy / iResolution.xy) * 2.0 - 1.0;
    vec3 cameraDir = vec3(0.0, 0.0, 0.8);
    vec3 cameraPlaneU = vec3(1.0, 0.0, 0.0);
    vec3 cameraPlaneV = vec3(0.0, 1.0, 0.0) * iResolution.y / iResolution.x;
    vec3 rayDir = cameraDir + screenPos.x * cameraPlaneU + screenPos.y * cameraPlaneV;
    vec3 rayPos = vec3(0.0, 2.0 * sin(iTime * 2.7), -12.0);

    rayPos.xz = rotate2d(rayPos.xz, iTime);
    rayDir.xz = rotate2d(rayDir.xz, iTime);

    ivec3 mapPos = ivec3(floor(rayPos + 0.));

    vec3 deltaDist = abs(vec3(length(rayDir)) / rayDir);

    ivec3 rayStep = ivec3(sign(rayDir));

    vec3 sideDist = (sign(rayDir) * (vec3(mapPos) - rayPos) + (sign(rayDir) * 0.5) + 0.5) * deltaDist;

    bvec3 mask;

    int iterations = 0;
    for (int i = 0; i < MAX_RAY_STEPS; i++) {
        ++iterations;
        // Basically we hit something, so stop the loop, and because of the masking
        //   code below, a voxel will be rendered at the last position.
        if (getVoxel(mapPos)) break;
        if (USE_BRANCHLESS_DDA) {
            //Thanks kzy for the suggestion!
            mask = lessThanEqual(sideDist.xyz, min(sideDist.yzx, sideDist.zxy));
            /*bvec3 b1 = lessThan(sideDist.xyz, sideDist.yzx);
            bvec3 b2 = lessThanEqual(sideDist.xyz, sideDist.zxy);
            mask.x = b1.x && b2.x;
            mask.y = b1.y && b2.y;
            mask.z = b1.z && b2.z;*/
            //Would've done mask = b1 && b2 but the compiler is making me do it component wise.

            //All components of mask are false except for the corresponding largest component
            //of sideDist, which is the axis along which the ray should be incremented.
            sideDist += vec3(mask) * deltaDist;
            mapPos += ivec3(vec3(mask)) * rayStep;
        }
        else {
            if (sideDist.x < sideDist.y) {
                if (sideDist.x < sideDist.z) {
                    sideDist.x += deltaDist.x;
                    mapPos.x += rayStep.x;
                    mask = bvec3(true, false, false);
                }
                else {
                    sideDist.z += deltaDist.z;
                    mapPos.z += rayStep.z;
                    mask = bvec3(false, false, true);
                }
            }
            else {
                if (sideDist.y < sideDist.z) {
                    sideDist.y += deltaDist.y;
                    mapPos.y += rayStep.y;
                    mask = bvec3(false, true, false);
                }
                else {
                    sideDist.z += deltaDist.z;
                    mapPos.z += rayStep.z;
                    mask = bvec3(false, false, true);
                }
            }
        }
    }

    vec3 color = vec3(1.0, 0.0, 0.0);
    if (mask.x) {
        color *= vec3(0.5);
    }
    if (mask.y) {
        color *= vec3(1.0);
    }
    if (mask.z) {
        color *= vec3(0.75);
    }

    // If the max distance was reached, we need this.
    // Otherwise we get a voxel rendered at the max distance.
    if (iterations == MAX_RAY_STEPS) color = vec3(0);
    fragColor.rgb = color;
    //fragColor.rgb = vec3(0.1 * noiseDeriv);
}
