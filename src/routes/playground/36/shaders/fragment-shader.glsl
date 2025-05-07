varying vec2 varying_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float PRECISION = 0.001;
const float EPSILON = 0.0005;
const float PI = 3.14159265359;
const vec3 COLOR_BACKGROUND = vec3(.741, .675, .82);
const vec3 COLOR_AMBIENT = vec3(0.42, 0.20, 0.1);

mat2 rotate2d(float theta) {
    float s = sin(theta), c = cos(theta);
    return mat2(c, -s, s, c);
}

float sdSphere(vec3 p, float r, vec3 offset)
{
    return length(p - offset) - r;
}

float opUnion(float d1, float d2) {
    return min(d1, d2);
}

float opSmoothUnion(float d1, float d2, float k) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h);
}

float opIntersection(float d1, float d2) {
    return max(d1, d2);
}

float opSmoothIntersection(float d1, float d2, float k) {
    float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) + k*h*(1.0-h);
}

float opSubtraction(float d1, float d2) {
    return max(-d1, d2);
}

float opSmoothSubtraction(float d1, float d2, float k) {
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return mix( d2, -d1, h ) + k*h*(1.0-h);
}

float opSubtraction2(float d1, float d2) {
    return max(d1, -d2);
}

float opSmoothSubtraction2(float d1, float d2, float k) {
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return mix( d1, -d2, h ) + k*h*(1.0-h);
}

float opSymX(vec3 p, float r, vec3 o)
{
    p.x = abs(p.x);
    return sdSphere(p, r, o);
}

float opSymXZ(vec3 p, float r, vec3 o)
{
    p.xz = abs(p.xz);
    return sdSphere(p, r, o);
}

float opRep(vec3 p, float r, vec3 o, vec3 c)
{
    vec3 q = mod(p+0.5*c,c)-0.5*c;
    return sdSphere(q, r, o);
}

float opRepLim(vec3 p, float r, vec3 o, float c, vec3 l)
{
    vec3 q = p-c*clamp(round(p/c),-l,l);
    return sdSphere(q, r, o);
}

float opDisplace(vec3 p, float r, vec3 o)
{
    float d1 = sdSphere(p, r, o);
    float d2 = sin(p.x)*sin(p.y)*sin(p.z) * cos(time);
    return d1 + d2;
}

float scene(vec3 p) {
    float d1 = sdSphere(p, 1., vec3(0, -1, 0));
    float d2 = sdSphere(p, 0.75, vec3(0, 0.5, 0));
    //return d1;
    //return d2;
    //return opUnion(d1, d2);
    //return opSmoothUnion(d1, d2, 0.2);
    //return opIntersection(d1, d2);
    //return opSmoothIntersection(d1, d2, 0.2);
    //return opSubtraction(d1, d2);
    //return opSmoothSubtraction(d1, d2, 0.2);
    //return opSubtraction2(d1, d2);
    //return opSmoothSubtraction2(d1, d2, 0.2);
    //return opSymX(p, 1., vec3(1, 0, 0));
    //return opSymXZ(p, 1., vec3(1, 0, 1));
    //return opRep(p, 1., vec3(0), vec3(8));
    //return opRepLim(p, 0.5, vec3(0), 2., vec3(1, 0, 1));
    return opDisplace(p, 1., vec3(0));
}

float rayMarch(vec3 ro, vec3 rd) {
    float depth = MIN_DIST;
    float d; // distance ray has travelled

    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        vec3 p = ro + depth * rd;
        d = scene(p);
        depth += d;
        if (d < PRECISION || depth > MAX_DIST) break;
    }

    d = depth;

    return d;
}

vec3 calcNormal(in vec3 p) {
    vec2 e = vec2(1, -1) * EPSILON;
    return normalize(
    e.xyy * scene(p + e.xyy) +
    e.yyx * scene(p + e.yyx) +
    e.yxy * scene(p + e.yxy) +
    e.xxx * scene(p + e.xxx));
}

mat3 camera(vec3 cameraPos, vec3 lookAtPoint) {
    vec3 cd = normalize(lookAtPoint - cameraPos);
    vec3 cr = normalize(cross(vec3(0, 1, 0), cd));
    vec3 cu = normalize(cross(cd, cr));

    return mat3(-cr, cu, -cd);
}

void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    vec3 col = vec3(0);
    vec3 lp = vec3(0);
    vec3 ro = vec3(0, 0, 3); // ray origin that represents camera position

    float cameraRadius = 2.;
//    ro.yz = ro.yz * cameraRadius * rotate2d(mix(-PI/2., PI/2., mouseUV.y));
//    ro.xz = ro.xz * rotate2d(mix(-PI, PI, mouseUV.x)) + vec2(lp.x, lp.z);

    vec3 rd = camera(ro, lp) * normalize(vec3(uv, -1)); // ray direction

    float d = rayMarch(ro, rd); // signed distance value to closest object

    if (d > MAX_DIST) {
        col = COLOR_BACKGROUND; // ray didn't hit anything
    } else {
        vec3 p = ro + rd * d; // point discovered from ray marching
        vec3 normal = calcNormal(p); // surface normal

        vec3 lightPosition = vec3(0, 2, 2);
        vec3 lightDirection = normalize(lightPosition - p) * .65; // The 0.65 is used to decrease the light intensity a bit

        float dif = clamp(dot(normal, lightDirection), 0., 1.) * 0.5 + 0.5; // diffuse reflection mapped to values between 0.5 and 1.0

        col = vec3(dif) + COLOR_AMBIENT;
    }
    // Output to screen
    fragmentColour = vec4(col,1.0);
}