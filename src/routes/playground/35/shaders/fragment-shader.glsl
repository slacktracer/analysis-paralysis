varying vec2 varying_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

//https://inspirnathan.com/posts/59-shadertoy-tutorial-part-13

/* The MIT License
** Copyright © 2022 Nathan Vaughn
** Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
**
** Example on how to create a shadow, apply gamma correction, and apply fog.
** Visit my tutorial to learn more: https://inspirnathan.com/posts/63-shadertoy-tutorial-part-16/
**
** Resources/Credit:
** Primitive SDFs: https://iquilezles.org/articles/distfunctions
** Soft Shadows: https://iquilezles.org/articles/rmshadows/
*/

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float PRECISION = 0.001;
const float EPSILON = 0.0005;

struct Surface {
    float sd; // signed distance value
    vec3 col; // color
};

Surface sdFloor(vec3 p, vec3 col) {
    float d = p.y + 1.;
    return Surface(d, col);
}

Surface sdSphere(vec3 p, float r, vec3 offset, vec3 col) {
    p = (p - offset);
    float d = length(p) - r;
    return Surface(d, col);
}

Surface opUnion(Surface obj1, Surface obj2) {
    if (obj2.sd < obj1.sd) return obj2;
    return obj1;
}

Surface scene(vec3 p) {
    vec3 floorColor = vec3(0.1 + 0.7*mod(floor(p.x) + floor(p.z), 2.0));
    Surface co = sdFloor(p, floorColor);
    co = opUnion(co, sdSphere(p, 1., vec3(0, 0, -2), vec3(1, 0, 0)));
    return co;
}

Surface rayMarch(vec3 ro, vec3 rd) {
    float depth = MIN_DIST;
    Surface co; // closest object

    for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
        vec3 p = ro + depth * rd;
        co = scene(p);
        depth += co.sd;
        if (co.sd < PRECISION || depth > MAX_DIST) break;
    }

    co.sd = depth;

    return co;
}

vec3 calcNormal(in vec3 p) {
    vec2 e = vec2(1, -1) * EPSILON;
    return normalize(
    e.xyy * scene(p + e.xyy).sd +
    e.yyx * scene(p + e.yyx).sd +
    e.yxy * scene(p + e.yxy).sd +
    e.xxx * scene(p + e.xxx).sd);
}

float softShadow(vec3 ro, vec3 rd, float mint, float tmax) {
    float res = 1.0;
    float t = mint;

    for(int i = 0; i < 16; i++) {
        float h = scene(ro + rd * t).sd;
        res = min(res, 8.0*h/t);
        t += clamp(h, 0.02, 0.10);
        if(h < 0.001 || t > tmax) break;
    }

    return clamp( res, 0.0, 1.0 );
}

void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    vec3 backgroundColor = vec3(0.835, 1, 1);

    vec3 col = vec3(0);
    vec3 ro = vec3(0, 0, 3); // ray origin that represents camera position
    vec3 rd = normalize(vec3(uv, -1)); // ray direction

    Surface co = rayMarch(ro, rd); // closest object

    if (co.sd > MAX_DIST) {
        col = backgroundColor; // ray didn't hit anything
    } else {
        vec3 p = ro + rd * co.sd; // point discovered from ray marching
        vec3 normal = calcNormal(p);

        vec3 lightPosition = vec3(cos(time), 2, sin(time));
        vec3 lightDirection = normalize(lightPosition - p);

        float dif = clamp(dot(normal, lightDirection), 0., 1.) + 0.5; // diffuse reflection

        float softShadow = clamp(softShadow(p, lightDirection, 0.02, 2.5), 0.1, 1.0);

        col = dif * co.col * softShadow;
    }

    col = mix(col, backgroundColor, 1.0 - exp(-0.0002 * co.sd * co.sd * co.sd)); // fog
    col = pow(col, vec3(1.0/2.2)); // Gamma correction
    // Output to screen
    fragmentColour = vec4(col,1.0);
}