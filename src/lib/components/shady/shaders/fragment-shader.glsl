varying vec2 vUvs;
varying vec3 myS;

uniform vec4 colour1;
uniform vec4 colour2;
uniform float time;

void main() {
    gl_FragColor = mix(
        vec4(0.9, 0.1, 0.1, 1.0),
        vec4(.1, .9, .2, 1.),
        vUvs.y
    );
}
