uniform float time;
uniform vec2 resolution;
varying vec2 varying_uv;

void main() {
    vec3 colour = vec3(1.0, 1.0, 1.0);
    
    vec2 uv = varying_uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    
    vec2 position = uv - sin(time * 5.);
    
    float distance = 1./length(position);
    distance *= .1;
    distance = pow(distance, 0.5 + ((sin(time) + 1.) / 2.));
    vec3 col = distance * vec3(1.0, 0.5, 0.25);
    col = 1.0 - exp( -col );


    //    gl_FragColor = vec4(length(uv), 0.0, 0.0, 1.0);
    gl_FragColor = vec4(col, 1.0);
}