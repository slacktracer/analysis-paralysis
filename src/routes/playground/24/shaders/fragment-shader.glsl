precision mediump float;

uniform float time;
uniform vec2 resolution;
in vec2 varying_uv;
out vec4 fragColor;

void main() {
    vec3 finalColor = vec3(1.0); // Initialize final color to white

    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    // Define the centers of the three glowing circles
    vec2 center1 = vec2(-0.6, 0.0);
    vec2 center2 = vec2(0.0, 0.0);
    vec2 center3 = vec2(0.6, 0.0);

    // Modulate intensity with time
    float intensity1 = 0.5 + 0.5 * sin(time);
    float intensity2 = 0.5 + 0.5 * sin(time + 2.0);
    float intensity3 = 0.5 + 0.5 * sin(time + 4.0);

    float glowFactor = 4.0;

    // --- Glow 1 ---
    vec2 position1 = uv - center1;
    float dist1 = length(position1);
    vec3 col1 = intensity1 * exp(-dist1 * glowFactor) * vec3(0.0, 0.5, 1.0); // Blue

    // --- Glow 2 ---
    vec2 position2 = uv - center2;
    float dist2 = length(position2);
    vec3 col2 = intensity2 * exp(-dist2 * glowFactor) * vec3(1.0, 1.0, 1.0); // White

    // --- Glow 3 ---
    vec2 position3 = uv - center3;
    float dist3 = length(position3);
    vec3 col3 = intensity3 * exp(-dist3 * glowFactor) * vec3(1.0, 0.1, 0.1); // Red

    // Combine the glows additively
    finalColor -= col1 + col2 + col3; // Subtract from white for a blending effect

    fragColor = vec4(finalColor, 1.0);
}