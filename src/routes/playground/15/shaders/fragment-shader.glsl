varying vec2 v_uv;
uniform vec2 uResolution;
uniform float uTime;

//out vec4 frag_color;

void main() {
    vec2 uv = v_uv;
    
    uv = uv * 2.0 - 1.0 + vec2(sin(uTime * 0.1), -cos(uTime * 0.1));
    uv.x *= uResolution.x / uResolution.y;
    
    vec3 colour = vec3(uv, 0.5);
    
    uv *= 5.0;
    
//    uv *= 0.0001;

    vec2 integer_coordinates = floor(abs(uv));
    vec2 fractional_coordinates = fract(uv);
    
    colour = vec3(fractional_coordinates, 0.5);
    
    colour = mod(abs(integer_coordinates), 2.0) == vec2(0.0) ? vec3(integer_coordinates / 10.0, 1.0) : colour;
    
    gl_FragColor = vec4(colour, 1.0);
}
