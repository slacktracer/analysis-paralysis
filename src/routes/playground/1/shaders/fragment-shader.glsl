varying vec2 v_uv;
uniform vec2 resolution;
uniform float time;

void main() {
    vec3 colour = vec3(1.0, 0.0, 1.0);

    gl_FragColor = vec4(colour, 1.0);
}