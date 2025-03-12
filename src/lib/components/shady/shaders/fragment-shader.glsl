varying vec2 v_uv;
uniform vec2 resolution;
uniform float time;

mat2 rotate2D(float angle) {
    float cosine = cos(angle);

    float sine = sin(angle);

    return mat2(cosine, -sine, sine, cosine);
}

float sdfCircle(vec2 position, float radius) {
    return length(position) - radius;
}

// note: set up basic colors
vec3 black = vec3(0.0);
vec3 white = vec3(1.0);
vec3 red = vec3(1.0, 0.0, 0.0);
vec3 blue = vec3(0.65, 0.85, 1.0);
vec3 orange = vec3(0.9, 0.6, 0.3);
vec3 yellow = vec3(0.0, 0.7, 0.7);

void main() {
    //[ 0-1 into 0-(pixels in the given axis, x or y)
    vec2 coordinates = (v_uv - 0.5) * resolution;
    //]

    //[ rotating the "screen"
    coordinates = coordinates * rotate2D(mod(time* 2., 360.0));
    //]

    vec3 color = vec3(v_uv.x, v_uv.y, 0.0);

    vec2 circle1position = coordinates - vec2(-300.,0.);
    float circle1radius = 100.;

    vec2 circle2position = coordinates - vec2(300.,0.);
    float circle2radius = 100.;

    float distanceToCircle1 = sdfCircle(circle1position, circle1radius);
    float distanceToCircle2 = sdfCircle(circle2position, circle2radius);

    vec3 circleColor1 = vec3(v_uv.y, v_uv.x, 0.0);
    vec3 circleColor2 = vec3(v_uv.y, v_uv.x, 0.0);

    //[ looking for good names for those
    float tp = 0.0;
    float f = 1.0;
    //]

    color = mix(circleColor1, color, smoothstep(tp - f, tp + f, distanceToCircle1));
    color = mix(circleColor2, color, smoothstep(tp - f, tp + f, distanceToCircle2));

    gl_FragColor = vec4(color, 1.0);
}


void main_01() {
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
