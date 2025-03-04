attribute vec3 myStuff;

varying vec2 vUvs;
varying vec3 myS;

void main() {
    vec4 localPosition = vec4(position, 1.0);

    gl_Position = projectionMatrix * modelViewMatrix * localPosition;

    vUvs = uv;

    myS = myStuff;
}
