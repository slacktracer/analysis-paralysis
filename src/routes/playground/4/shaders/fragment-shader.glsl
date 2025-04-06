uniform vec2 uResolution;
uniform float uTime;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void main() {
    vec2 uv = gl_FragCoord.xy / uResolution.xy;
    
    uv -= 0.5;
    uv *= 2.0;
    uv.x *= uResolution.x / uResolution.y;
    
    vec3 colour = vec3(1.0, 2.0, 1.0);
    
    float d = sdBox(uv, vec2(0.2));
    d -= 0.1;
    d = abs(d);
    d = 0.025 / d;
    
    colour *= vec3(uv, 0.12);
    
    colour *= d;

    gl_FragColor = vec4(colour, 1.0);
}