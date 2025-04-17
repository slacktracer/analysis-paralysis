uniform vec2 uResolution;
uniform float uTime;

varying vec2 v_uv;

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
//    vec2 uv = gl_FragCoord.xy / uResolution.xy;
    vec2 uv = v_uv;

    uv -= 0.5;
    uv *= 2.0;
    uv.x *= uResolution.x / uResolution.y;
    
    vec2 old_uv = uv;
    
//    uv = fract(uv * 2.0);
    uv = fract(uv);
    uv -= 0.5;
    uv *= 2.0;

    vec3 colour = vec3(1.0, 1.0, 1.0);
    
    float d = sdCircle(uv, 0.1);

//    colour = vec3(uv, 0.0);
    colour = vec3(abs(uv), 0.0);
    
    colour = mix(vec3(abs(uv), 0.0), colour, smoothstep(0.01, 0.02, d));

    gl_FragColor = vec4(colour, 1.0);
}