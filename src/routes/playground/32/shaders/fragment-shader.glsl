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
    return length(p) - r;
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

mat3 camera(vec3 cameraPos, vec3 lookAtPoint) {
    vec3 cd = normalize(lookAtPoint - cameraPos); // camera direction
    vec3 cr = normalize(cross(vec3(0, 1, 0), cd)); // camera right
    vec3 cu = normalize(cross(cd, cr)); // camera up

    return mat3(-cr, cu, -cd);
}

vec3 phong(vec3 lightDir, vec3 normal, vec3 rd) {
    // ambient
    float k_a = 0.6;
    vec3 i_a = vec3(0.7, 0.7, 0);
    vec3 ambient = k_a * i_a;

    // diffuse
    float k_d = 0.5;
    float dotLN = clamp(dot(lightDir, normal), 0., 1.);
    vec3 i_d = vec3(0.7, 0.5, 0);
    vec3 diffuse = k_d * dotLN * i_d;

    // specular
    float k_s = 0.6;
    float dotRV = clamp(dot(reflect(lightDir, normal), -rd), 0., 1.);
    vec3 i_s = vec3(1, 1, 1);
    float alpha = 10.;
    vec3 specular = k_s * pow(dotRV, alpha) * i_s;

    return ambient + diffuse + specular;
}

void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    vec3 backgroundColor = vec3(0.835, 1, 1);
    vec3 col = vec3(0);

    vec3 lp = vec3(0); // lookat point (aka camera target)
    vec3 ro = vec3(0, 0, 3);

    vec3 rd = camera(ro, lp) * normalize(vec3(uv, -1)); // ray direction

    float d = rayMarch(ro, rd);

    if (d > MAX_DIST) {
        col = backgroundColor;
    } else {
        vec3 p = ro + rd * d; // point on surface found by ray marching
        vec3 normal = calcNormal(p); // surface normal

        // light #1
        vec3 lightPosition1 = vec3(-8, -6, -5);
        vec3 lightDirection1 = normalize(lightPosition1 - p);
        float lightIntensity1 = 0.6;

        // light #2
        vec3 lightPosition2 = vec3(1, 1, 1);
        vec3 lightDirection2 = normalize(lightPosition2 - p);
        float lightIntensity2 = 0.7;

        // final sphere color
        col = lightIntensity1 * phong(lightDirection1, normal, rd);
        col += lightIntensity2 * phong(lightDirection2, normal , rd);
    }



    // Output to screen
    fragmentColour = vec4(col,1.0);
}