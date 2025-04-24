varying vec2 varying_uv;

void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

    varying_uv = uv;
}