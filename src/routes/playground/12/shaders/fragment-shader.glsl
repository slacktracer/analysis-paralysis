varying vec2 v_uv;
uniform vec2 uResolution;
uniform float time;

void main() {
    vec2 xy = v_uv;
    xy.x *= uResolution.x / uResolution.y;
    xy = xy * 5.0;
    vec2 i = floor(xy);
    xy = fract(xy);
    
    vec3 colour = vec3(xy, xy.y);
    
    if (mod(i, 2.0) == vec2(0.0)) colour = vec3(0.0);
//    colour = vec3(i, 0.0);
    gl_FragColor = vec4(colour, 1.0);
}
