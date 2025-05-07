varying vec2 varying_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

#define MAX_MARCHING_STEPS 255
#define MIN_DIST 0.0
#define MAX_DIST 100.0
#define PRECISION 0.001

struct Surface {
    float sd; // signed distance value
    vec3 col; // color
};

Surface sdSphere(vec3 p, float r, vec3 offset, vec3 col)
{
    float d = length(p - offset) - r;
    return Surface(d, col);
}

Surface sdFloor(vec3 p, vec3 col) {
    float d = p.y + 1.;
    return Surface(d, col);
}

Surface minWithColor(Surface obj1, Surface obj2) {
    if (obj2.sd < obj1.sd) return obj2; // The sd component of the struct holds the "signed distance" value
    return obj1;
}

Surface sdScene(vec3 p) {
    Surface sphereLeft = sdSphere(p, 1., vec3(-2.5, 0, -2), vec3(0, .8, .8));
    Surface sphereRight = sdSphere(p, 1., vec3(2.5, 0, -2), vec3(1, 0.58, 0.29));
    Surface co = minWithColor(sphereLeft, sphereRight);

    vec3 floorColor = vec3(1. + 0.7*mod(floor(p.x) + floor(p.z), 2.0));
    co = minWithColor(co, sdFloor(p, floorColor));
    return co;
}

Surface rayMarch(vec3 ro, vec3 rd, float start, float end) {
    float depth = start;
    Surface co; // closest object

    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        vec3 p = ro + depth * rd;
        co = sdScene(p);
        depth += co.sd;
        if (co.sd < PRECISION || depth > end) break;
    }

    co.sd = depth;

    return co;
}

vec3 calcNormal(in vec3 p) {
    vec2 e = vec2(1.0, -1.0) * 0.0005; // epsilon
    return normalize(
    e.xyy * sdScene(p + e.xyy).sd +
    e.yyx * sdScene(p + e.yyx).sd +
    e.yxy * sdScene(p + e.yxy).sd +
    e.xxx * sdScene(p + e.xxx).sd);
}
void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    vec3 backgroundColor = vec3(0.835, 1, 1);

    vec3 col = vec3(0);
    vec3 ro = vec3(0, 0, 3); // ray origin that represents camera position
    vec3 rd = normalize(vec3(uv, -1)); // ray direction

    Surface co = rayMarch(ro, rd, MIN_DIST, MAX_DIST); // closest object

    if (co.sd > MAX_DIST) {
        col = backgroundColor; // ray didn't hit anything
    } else {
        vec3 p = ro + rd * co.sd; // point on sphere or floor we discovered from ray marching
        vec3 normal = calcNormal(p);
        vec3 lightPosition = vec3(2, 2, 7);
        vec3 lightDirection = normalize(lightPosition - p);

        // Calculate diffuse reflection by taking the dot product of
        // the normal and the light direction.
        float dif = clamp(dot(normal, lightDirection), 0.3, 1.);

        // Multiply the diffuse reflection value by an orange color and add a bit
        // of the background color to the sphere to blend it more with the background.
        col = dif * co.col + backgroundColor * .2;
    }

    // Output to screen
    fragmentColour = vec4(col,1.0);
}