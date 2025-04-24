varying vec2 v_uv;
uniform vec2 uResolution;
uniform float uTime;

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void main() {
    vec2 local_uv = v_uv;

    local_uv = v_uv * 2.0 - (1.0 - uTime * 0.1);
    local_uv.x *= uResolution.x / uResolution.y;

    float x = sdCircle(abs(local_uv - 3.0), 0.1);
    
    vec3 colour = vec3(0.0, local_uv);
    
    colour = mix(vec3(0.0), colour, smoothstep(0.38, 0.62, x));

    gl_FragColor = vec4(colour, 1.0);
}