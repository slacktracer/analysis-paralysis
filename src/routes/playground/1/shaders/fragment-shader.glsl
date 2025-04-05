uniform vec2 resolution;
uniform float time;

varying vec2 v_uv;

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

float makeCircle(vec2 position, float radius) {
    float distance = sdCircle(position, radius);
    
    float edgeThickness = 0.005;
    
    return smoothstep(edgeThickness, -edgeThickness, distance);
}

void main() {
    vec2 center1 = vec2(0.8, 0.8);
    float circle1 = makeCircle(v_uv - vec2(abs(sin(time))), clamp(abs(sin(time)), 0.3, 0.8));
    float circle2 = makeCircle(v_uv - vec2(0.1), 0.1);
    float circle3 = makeCircle(v_uv - vec2(0.8), 0.3);
    
    vec3 color = vec3(0.34, 0.67, 0.98);
    
    color = mix(color, vec3(1.0, v_uv), circle1);
    color = mix(color, vec3(1. - v_uv, 0.0), circle2);
    color = mix(color, vec3(0.0, v_uv), circle3);
    
    gl_FragColor = vec4(color, 1.0);
}

void main_() {
    // Center the circle at (0.5, 0.5)
    vec2 center = vec2(0.5, 0.5);

    // Move v_uv into a space where (0,0) is the center
    vec2 pos = v_uv - center;
    
    vec2 pos2 = v_uv - vec2(0.05, 0.95);
    vec2 pos3 = v_uv - vec2(0.9, 0.1);

    // Compute signed distance
    float distanceToCircle = sdCircle(pos, 0.3); // radius in normalized units
    float distanceToCircle2 = sdCircle(pos2, 0.3); // radius in normalized units
    float distanceToCircle3 = sdCircle(pos3, 0.3); // radius in normalized units

    // Smooth edge for antialiasing
    float edgeThickness = 0.005;
    
    float alpha = smoothstep(edgeThickness, -edgeThickness, distanceToCircle);
    float alpha2 = smoothstep(edgeThickness, -edgeThickness, distanceToCircle2);
    float alpha3 = smoothstep(edgeThickness, -edgeThickness, distanceToCircle3);

    vec3 color = mix(vec3(0.2, 0.4, 0.6), vec3(1.0), alpha); // gray background, white circle
    color = mix(color, vec3(1.0), alpha2); // gray background, white circle
    color = mix(color, vec3(1.0), alpha3); // gray background, white circle

    gl_FragColor = vec4(color, 1.0);
}
