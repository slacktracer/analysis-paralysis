varying vec2 varying_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

mat3 rotateX(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
    vec3(1, 0, 0),
    vec3(0, c, -s),
    vec3(0, s, c)
    );
}

// Rotation matrix around the Y axis.
mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
    vec3(c, 0, s),
    vec3(0, 1, 0),
    vec3(-s, 0, c)
    );
}

// Rotation matrix around the Z axis.
mat3 rotateZ(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
    vec3(c, -s, 0),
    vec3(s, c, 0),
    vec3(0, 0, 1)
    );
}

// Identity matrix.
mat3 identity() {
    return mat3(
    vec3(1, 0, 0),
    vec3(0, 1, 0),
    vec3(0, 0, 1)
    );
}

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float PRECISION = 0.001;

struct Surface {
    float sd; // signed distance value
    vec3 col; // color
    int id; // identifier for each surface/object
};

/*
Surface IDs:
1. Floor
2. Box
*/

Surface sdBox( vec3 p, vec3 b, vec3 offset, vec3 col, mat3 transform)
{
    p = (p - offset) * transform;
    vec3 q = abs(p) - b;
    float d = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
    return Surface(d, col, 2);
}

Surface sdFloor(vec3 p, vec3 col) {
    float d = p.y + 1.;
    return Surface(d, col, 1);
}

Surface minWithColor(Surface obj1, Surface obj2) {
    if (obj2.sd < obj1.sd) return obj2;
    return obj1;
}

Surface sdScene(vec3 p) {
    vec3 floorColor = vec3(.5 + 0.3*mod(floor(p.x) + floor(p.z), 2.0));
    Surface co = sdFloor(p, floorColor);
    co = minWithColor(co, sdBox(p, vec3(1), vec3(0, 0.5, -4), vec3(1, 0, 0), identity()));
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

    const float PI = 3.14159265359;
    vec3 rd = normalize(vec3(uv, -1));
    rd *= rotateY(sin(time * 0.5) * PI); // 0.5 is used to slow the animation down

    Surface co = rayMarch(ro, rd, MIN_DIST, MAX_DIST); // closest object

    if (co.sd > MAX_DIST) {
        col = backgroundColor; // ray didn't hit anything
    } else {
        vec3 p = ro + rd * co.sd; // point on cube or floor we discovered from ray marching
        vec3 normal = calcNormal(p);

        // check material ID
        if( co.id == 1 ) // floor
        {
            col = co.col;
        } else {
            // lighting
            vec3 lightPosition = vec3(2, 2, 7);
            vec3 lightDirection = normalize(lightPosition - p);

            // color
            float dif = clamp(dot(normal, lightDirection), 0.3, 1.); // diffuse reflection
            col = dif * co.col + backgroundColor * .2; // Add a bit of background color to the diffuse color
        }
    }

    // Output to screen
    fragmentColour = vec4(col,1.0);
}