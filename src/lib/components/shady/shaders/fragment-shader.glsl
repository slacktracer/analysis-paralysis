varying vec2 v_uv;
uniform vec2 resolution;
uniform float time;

void main() {
    vec3 color = vec3(v_uv.xy, 0.1);

    //[ -1.0 to 1.0 respecting aspect ratio
    vec2 uv = 2.0 * v_uv.xy - 1.0;

    float aspect = resolution.x / resolution.y;

    uv.x *= aspect;
    //]

    float invertedLengthOfUV = 1.0 - length(uv);

    float smoothBorder = smoothstep(0.4999, 0.5111, invertedLengthOfUV);

    vec2 absoluteUVXY = abs(uv.xy);

    gl_FragColor = vec4(absoluteUVXY, smoothBorder, 1.0);
}
