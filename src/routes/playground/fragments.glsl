varying vec2 v_uv;
uniform vec2 resolution;
uniform float time;

// note: set up basic colors
vec3 black = vec3(0.0);
vec3 white = vec3(1.0);
vec3 red = vec3(1.0, 0.0, 0.0);
vec3 blue = vec3(0.65, 0.85, 1.0);
vec3 orange = vec3(0.9, 0.6, 0.3);
vec3 yellow = vec3(0.0, 0.7, 0.7);

varying vec2 vUvs;
uniform vec2 resolution;
uniform float time;

vec3 YELLOW = vec3(1.0, 1.0, 0.5);
vec3 BLUE = vec3(0.25, 0.25, 1.0);
vec3 RED = vec3(1.0, 0.25, 0.25);
vec3 GREEN = vec3(0.25, 1.0, 0.25);
vec3 PURPLE = vec3(1.0, 0.25, 1.0);

float inverseLerp(float v, float minValue, float maxValue) {
    return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

vec3 BackgroundColour() {
    float distFromCenter = length(abs(vUvs - 0.5));

    float vignette = 1.0 - distFromCenter;
    vignette = smoothstep(0.0, 0.7, vignette);
    vignette = remap(vignette, 0.0, 1.0, 0.3, 1.0);

    return vec3(vignette);
}

vec3 drawGrid(
    vec3 colour, vec3 lineColour, float cellSpacing, float lineWidth) {
    vec2 center = vUvs - 0.5;
    vec2 cells = abs(fract(center * resolution / cellSpacing) - 0.5);
    float distToEdge = (0.5 - max(cells.x, cells.y)) * cellSpacing;
    float lines = smoothstep(0.0, lineWidth, distToEdge);

    colour = mix(lineColour, colour, lines);

    return colour;
}

float sdfCircle(vec2 p, float r) {
    return length(p) - r;
}

float sdfLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

    return length(pa - ba * h);
}

float sdfBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Inigo Quilez
// https://iquilezles.org/articles/distfunctions2d/
float sdfHexagon( in vec2 p, in float r ) {
    const vec3 k = vec3(-0.866025404, 0.5, 0.577350269);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
    return length(p)*sign(p.y);
}

float opUnion(float d1, float d2) {
    return min(d1, d2);
}

float opSubtraction(float d1, float d2) {
    return max(-d1, d2);
}

float opIntersection(float d1, float d2) {
    return max(d1, d2);
}

mat2 rotate2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float softMax(float a, float b, float k) {
    return log(exp(k * a) + exp(k * b)) / k;
}

float softMin(float a, float b, float k) {
    return -softMax(-a, -b, k);
}

float softMinValue(float a, float b, float k) {
    float h = exp(-b * k) / (exp(-a * k) + exp(-b * k));
    // float h = remap(a - b, -1.0 / k, 1.0 / k, 0.0, 1.0);
    return h;
}

void main() {
    vec2 pixelCoords = (vUvs - 0.5) * resolution;

    vec3 colour = vec3(1.0, 1.0, 1.0);

    float circle = sdfCircle(pixelCoords - vec2(0.0, time * 10.0), time * 10.0);

    colour = mix(vec3(0.0, 0.0, 0.0), colour, smoothstep(-1.0, 0.0, circle));

    gl_FragColor = vec4(colour, 1.0);
}

void main_03() {
    vec3 color = vec3(.34, .65, .12);

    //[ -1.0 to 1.0 respecting aspect ratio
    vec2 uv = 2.0 * v_uv.xy - 1.0;

    float aspect = resolution.x / resolution.y;

    uv.x *= aspect;
    //]

    vec3 circleColor = vec3(length(uv), length(uv), length(uv));

    color = mix(circleColor,color, smoothstep(0.50, 0.59, length(uv)));

//    if ( > 0.5) color =

    gl_FragColor = vec4(color, 1.);
}

void main_02() {
    //[ 0-1 into 0-(pixels in the given axis, x or y)
    vec2 coordinates = (v_uv - 0.5) * resolution;
    //]

    //[ rotating the "screen"
    coordinates = coordinates * rotate2D(mod(time* 2., 360.0));
    //]

    vec3 color = vec3(v_uv.x, v_uv.y, 0.0);

    vec2 circle1position = coordinates - vec2(-300.,0.);
    float circle1radius = 100.;

    vec2 circle2position = coordinates - vec2(300.,0.);
    float circle2radius = 100.;

    float distanceToCircle1 = sdfCircle(circle1position, circle1radius);
    float distanceToCircle2 = sdfCircle(circle2position, circle2radius);

    vec3 circleColor1 = vec3(v_uv.y, v_uv.x, 0.0);
    vec3 circleColor2 = vec3(v_uv.y, v_uv.x, 0.0);

    //[ looking for good names for those
    float tp = 0.0;
    float f = 1.0;
    //]

    color = mix(circleColor1, color, smoothstep(tp - f, tp + f, distanceToCircle1));
    color = mix(circleColor2, color, smoothstep(tp - f, tp + f, distanceToCircle2));

    gl_FragColor = vec4(color, 1.0);
}


void main_01() {
    vec3 color = vec3(v_uv.xy, 0.1);

    //[ -1.0 to 1.0 respecting aspect ratio
    vec2 uv = 2.0 * v_uv.xy - 1.0;

    float aspect = resolution.x / resolution.y;

    uv.x *= aspect;
    //]

    float invertedLengthOfUV = 1.0 - length(uv);

    float smoothBorder = smoothstep(0.4999, 0.5111, invertedLengthOfUV);

    vec2 absoluteUVXY = abs(uv.xy);

    gl_FragColor = vec4(absoluteUVXY, smoothBorder, 1.0);
}
