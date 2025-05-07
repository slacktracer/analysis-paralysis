varying vec2 varying_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

#define MAX_MARCHING_STEPS 255
#define MIN_DIST 0.0
#define MAX_DIST 100.0
#define PRECISION 0.001

float sdSphere(vec3 p, float r)
{
    return length(p) - r; // p is the test point and r is the radius of the sphere
}


float rayMarch(vec3 ro, vec3 rd, float start, float end) {
    float depth = start;

    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        vec3 p = ro + depth * rd;
        float d = sdSphere(p, 1.);
        depth += d;
        if (d < PRECISION || depth > end) break;
    }

    return depth;
}

vec3 calcNormal(vec3 p) {
    vec2 e = vec2(1.0, -1.0) * 0.0005; // epsilon
    float r = 1.; // radius of sphere
    return normalize(
    e.xyy * sdSphere(p + e.xyy, r) +
    e.yyx * sdSphere(p + e.yyx, r) +
    e.yxy * sdSphere(p + e.yxy, r) +
    e.xxx * sdSphere(p + e.xxx, r));
}


void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    vec3 col = vec3(0);

    vec3 ro = vec3(0, 0, 2);
    vec3 rd = normalize(vec3(uv, -1));
    float d = rayMarch(ro, rd, MIN_DIST, MAX_DIST); // distance to sphere


    if (d > MAX_DIST) {
        col = vec3(0.9); // ray didn't hit anything
    } else {
        vec3 p = ro + rd * d; // point on sphere we discovered from ray marching
        vec3 normal = calcNormal(p);
        vec3 lightPosition = vec3(3., 0., 1. + abs(sin(time)) * 4.);
        vec3 lightDirection = normalize(lightPosition - p);

        // Calculate diffuse reflection by taking the dot product of
        // the normal and the light direction.
        float dif = clamp(dot(normal, lightDirection), 0.3, 1.);
        col = vec3(dif) * vec3(1, 0.58, 0.29);

    }



    // Output to screen
    fragmentColour = vec4(col,1.0);
}