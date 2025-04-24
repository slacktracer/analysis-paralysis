precision mediump float;

in vec2 varying_uv;
out vec4 fragColor;
uniform float time;
uniform vec2 resolution;

float sdEquilateralTriangle( in vec2 p, in float r ) {
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}

void main() {
    vec3 color = vec3(.0);

    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
     
    vec2 position = vec2(uv);
    
    float triangle = sdEquilateralTriangle(position + 0.3, 0.6);
    vec3 color1 = mix(vec3(0.5), color, smoothstep(0.0, 0.002, triangle));
    
    float triangle2 = sdEquilateralTriangle(position - 0.3, 0.6);
    vec3 color2 = mix(vec3(0.5), color, smoothstep(0.0, 0.002, triangle2));
    
    color = color1 + color2;
    
    fragColor = vec4(color, 1.0);
}
