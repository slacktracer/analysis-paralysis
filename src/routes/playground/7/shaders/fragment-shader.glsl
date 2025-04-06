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
    
    vec3 colour = vec3(1.0, 1.0, 1.0);
    
    colour = vec3(pixelCoords, 0.0);

    float box = sdBox(pixelCoords + vec2(0.0, 0.0), vec2(100., 100.));
    
    colour = mix(colour, vec3(0.0,0.0,0.0), box);

    gl_FragColor = vec4(colour, 1.0);
}