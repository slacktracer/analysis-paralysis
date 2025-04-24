varying vec2 v_uv;
uniform vec2 resolution;
uniform float time;
out vec4 fragmentColour;

void main() {
    vec3 bg = vec3(.14,.18,.21);
//    vec3 bg = vec3(.84,.18,.71);
    
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    float d = length(uv) - 0.2; // signed distance function

    vec3 col = vec3(step(0., -d)); // create white circle with black background
    
    float glow = 0.01/d; // create glow and diminish it with distance
    glow = clamp(glow, 0., 1.); // remove artifacts
    col += glow; // add glow
    
//    bg = bg + col;

    float d1 = length(uv - 0.5) - 0.4; // signed distance function

    vec3 col1 = vec3(step(0., -d1)); // create white circle with black background

    float glow1 = 0.0075/d1; // create glow and diminish it with distance
    glow1 = clamp(glow1, 0., 1.); // remove artifacts
    col1 += glow1; // add glow

    float d2 = length(uv + 0.5) - 0.05; // signed distance function

    vec3 col2 = vec3(step(0., -d2)); // create white circle with black background

    float glow2 = 0.03/d2; // create glow and diminish it with distance
    glow2 = clamp(glow2, 0., 1.); // remove artifacts
    col2 += glow2; // add glow

    fragmentColour = vec4(bg + col + col1 + col2,1.0); // output color
}