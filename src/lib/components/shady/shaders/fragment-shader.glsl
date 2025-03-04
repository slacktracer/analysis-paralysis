varying vec2 vUvs;
varying vec3 myS;

uniform vec4 colour1;
uniform vec4 colour2;
uniform float time;

void main() {
    vec4 colour = vec4(vec3(cos((time))), 1.0);

    if (vUvs.x > 0.5) {
        colour = vec4(vec3(sin((time))), 1.0);
    }

    gl_FragColor = colour;
}
