#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;
uniform float tapValue;
uniform vec3 lineColor0;
uniform vec3 lineColor1;
uniform vec3 lineColor2;
uniform vec3 lineColor3;

out vec4 fragColor;

float hash(float n) {
    return fract(sin(n) * 753.5453123);
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float n = p.x + p.y * 157.0;
    return mix(
        mix(hash(n + 0.0), hash(n + 1.0), f.x),
        mix(hash(n + 157.0), hash(n + 158.0), f.x),
        f.y
    );
}

float fbm(vec2 p, vec3 a) {
    float v = 0.0;
    v += noise(p * a.x) * 0.50;
    v += noise(p * a.y) * 1.50;
    v += noise(p * a.z) * 0.125 * 0.1;
    return v;
}

vec3 drawLines(vec2 uv, vec3 fbmOffset, vec3 color0, vec3 color1, vec3 color2, vec3 color3, float secs) {
    float timeVal = secs * 0.1;
    vec3 finalColor = vec3(0.0);

    for (int i = 0; i < 4; ++i) {
        float indexAsFloat = float(i);
        float amp = 80.0 + (indexAsFloat * 0.0);
        float period = 2.0 + (indexAsFloat + 2.0);
        float thickness = mix(0.4, 0.2, noise(uv * 2.0));
        float t = abs(1.0 / (sin(uv.y + fbm(uv + timeVal * period, fbmOffset)) * amp) * thickness);
        if (i == 0) finalColor += t * color0;
        if (i == 1) finalColor += t * color1;
        if (i == 2) finalColor += t * color2;
        if (i == 3) finalColor += t * color3;
    }

    for (int i = 0; i < 4; ++i) {
        float indexAsFloat = float(i);
        float amp = 40.0 + (indexAsFloat * 5.0);
        float period = 9.0 + (indexAsFloat + 2.0);
        float thickness = mix(0.1, 0.1, noise(uv * 12.0));
        float t = abs(1.0 / (sin(uv.y + fbm(uv + timeVal * period, fbmOffset)) * amp) * thickness);
        if (i == 0) finalColor += t * color0;
        if (i == 1) finalColor += t * color1;
        if (i == 2) finalColor += t * color2;
        if (i == 3) finalColor += t * color3;
    }

    return finalColor;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (fragCoord.xy / iResolution.xy) * 2.0 - 1.0;
    uv *= 1.0 + 0.5;

    vec3 finalColor = vec3(0.0);
    float spread = abs(tapValue);
    float t = sin(iTime) * 0.5 + 0.5;
    float pulse = mix(0.006, 0.009, t);

    finalColor = drawLines(uv, vec3(65.2, 40.0, 4.0), lineColor0, lineColor1, lineColor2, lineColor3, iTime * 0.1) * pulse;
    finalColor += drawLines(uv, vec3(5.0 * spread / 2.0, 2.1 * spread, 1.0), lineColor0, lineColor1, lineColor2, lineColor3, iTime);

    fragColor = vec4(finalColor, 1.0);
}