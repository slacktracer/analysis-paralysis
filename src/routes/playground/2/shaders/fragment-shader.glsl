uniform vec2 uResolution;
uniform float uTime;

void main() {
    vec2 uv = gl_FragCoord.xy / uResolution.xy;
    
    uv -= 0.5;
    uv *= 2.0;
    uv.x *= uResolution.x / uResolution.y;
    
    uv = fract(uv);
    uv -= 0.5;

    vec3 colour = vec3(1.0, 2.0, 3.0);
    
    float d = length(uv);
//    d -= 0.5;
    d = sin(d * 5.0 + uTime) / 5.0;
    d = abs(d);
//    d = smoothstep(0.0, 0.1, d);
    d = 0.02 / d;
    
    colour *= d;

    gl_FragColor = vec4(colour, 1.0);
}