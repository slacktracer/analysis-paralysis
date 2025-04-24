precision mediump float;

// Your custom uniforms and varyings
uniform float time;
uniform vec2 resolution;
in vec2 varying_uv;
out vec4 fragColor;

float sdEquilateralTriangle( in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}

void main() {
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    
    vec3 color = vec3(0.0, 0.0, 0.0);
    
    float t1 = sdEquilateralTriangle(vec2(uv.x + 0.5, uv.y), 0.3);
    float t2 = sdEquilateralTriangle(vec2(uv.x - 0.5, uv.y), 0.3);
    float t3 = sdEquilateralTriangle(vec2(uv.x, uv.y), 0.3);
    
    color = mix(vec3(1.0), color, smoothstep(-0.001, 0.001, t1));
    color = mix(vec3(1.0), color, smoothstep(-0.001, 0.001, t2));
    color = mix(vec3(1.0), color, smoothstep(-0.001, 0.001, t3));
    
    fragColor = vec4(color, 1.0);
}