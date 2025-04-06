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
    vec2 pixelCoords = (v_uv - 0.5) * uResolution;
    
    vec3 colour = vec3(0.0, 0.0, 0.0);
    
    float box1 = sdBox(pixelCoords + vec2(0.0  + sin(uTime) * -200., 0.0 + sin(uTime) * 200.), vec2(100., 100.));
    float box2 = sdBox(pixelCoords - 200. * (sin(uTime) * 2.), vec2(100., 100.));
    float box3 = sdBox(pixelCoords + vec2(200., 200.* (sin(uTime) * 2.)), vec2(100., 100.* (abs(sin(uTime)) * 2.)));
    
    colour = mix(vec3(v_uv, 0.0), colour, step(0.0, box1));
    colour = mix(vec3(v_uv.x, 0., v_uv.y), colour, step(0.0, box2));
    colour = mix(vec3(0.0, v_uv), colour, step(0.0, box3));

    gl_FragColor = vec4(colour, 1.0);
}