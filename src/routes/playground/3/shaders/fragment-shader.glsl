uniform vec2 uResolution;
uniform float uTime;

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void main() {
    vec2 uv = gl_FragCoord.xy / uResolution.xy;
    
    uv -= 0.5;
    uv *= 2.0;
    uv.x *= uResolution.x / uResolution.y;
    
    vec3 colour = vec3(0.0, 2.0, 0.0);
    
    float d = sdCircle(uv - vec2(abs(cos(uTime)), abs(sin(uTime))) + vec2(0.5, 0.5), 0.1);
    d -= 0.1;
    d = abs(d);
    d = 0.005 / d;
    
    colour *= d;

    gl_FragColor = vec4(colour, 1.0);
}