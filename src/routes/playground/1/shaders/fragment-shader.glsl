varying vec2 v_uv;
uniform vec2 resolution;
uniform float time;

float plot(vec2 st, float pct){
    return  smoothstep( pct-0.02, pct, st.y) -
    smoothstep( pct, pct+0.02, st.y);
}

void main() {
//    vec2 st = v_uv*resolution;
//    vec2 st = gl_FragCoord.xy/resolution;

float y = smoothstep(0.1,0.9,v_uv.x);
    vec3 color = vec3(y);

    // Plot a line
    float pct = plot(v_uv, y);
    
    color = (1.0-pct)*color+pct*vec3(1.0,0.0,0.0);
    
//    if(st.x >.1) color = vec3(0.4,0.8,0.5);

    gl_FragColor = vec4(color,1.0);
}