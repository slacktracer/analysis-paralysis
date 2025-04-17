uniform vec2 resolution;
uniform float uTime;
uniform vec3 point;

varying vec2 v_uv;

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void main() {
    vec3 colour = vec3(point);
    
//    if (resolution.y == 0.0) { colour = vec3(0.5); }
//    if (resolution.x == 0.0) { colour = vec3(0.25); }

    gl_FragColor = vec4(colour / 0.0, 1.0);
}
