varying vec2 varying_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float PRECISION = 0.001;

float sdSphere(vec3 p, float r )
{
    vec3 offset = vec3(0, 0, -2);
    return length(p - offset) - r;
}

float sdScene(vec3 p) {
    return sdSphere(p, 1.);
}

float rayMarch(vec3 ro, vec3 rd) {
    float depth = MIN_DIST;

    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        vec3 p = ro + depth * rd;
        float d = sdScene(p);
        depth += d;
        if (d < PRECISION || depth > MAX_DIST) break;
    }

    return depth;
}

vec3 calcNormal(vec3 p) {
    vec2 e = vec2(1.0, -1.0) * 0.0005;
    return normalize(
    e.xyy * sdScene(p + e.xyy) +
    e.yyx * sdScene(p + e.yyx) +
    e.yxy * sdScene(p + e.yxy) +
    e.xxx * sdScene(p + e.xxx));
}

void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    vec3 backgroundColor = vec3(0.1);
    vec3 col = vec3(0);

    vec3 ro = vec3(0, 0, 3);
    vec3 rd = normalize(vec3(uv, -1));

    float d = rayMarch(ro, rd);

    if (d > MAX_DIST) {
        col = backgroundColor;
    } else {
        vec3 p = ro + rd * d;
        vec3 normal = calcNormal(p);
        vec3 lightPosition = vec3(4, 4, 7);
        vec3 lightDirection = normalize(lightPosition - p);

        float diffuse = clamp(dot(normal, lightDirection), 0., 1.);
        vec3 diffuseColor = vec3(0, 0.6, 1);

//        float fresnel = pow(clamp(1. - dot(normal, -rd), 0., 1.), 5.);
//        vec3 rimColor = vec3(1, 1, 1);

//        col = diffuse * diffuseColor + fresnel * rimColor; // add the fresnel contribution

        float fresnel = pow(clamp(1. - dot(normal, -rd), 0., 1.), 0.5);
        vec3 rimColor = vec3(1, 0., 1);

        col = diffuse * diffuseColor + fresnel * rimColor;
    }

    // Output to screen
    fragmentColour = vec4(col,1.0);
}