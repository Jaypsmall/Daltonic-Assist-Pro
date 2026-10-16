#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uModo;
uniform sampler2D uTexture;

out vec4 fragColor;

float ruidoAtomico(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 58.233))) * 23758.5453);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;
    vec4 texColor = texture(uTexture, uv);
    vec3 color = texColor.rgb;

    // Máscara Rojo: R dominante sobre G y B
    float maxG_B = max(color.g, color.b);
    float mascara = step(0.3, color.r - maxG_B) * step(0.3, color.r);

    // Efectos
    float onda = step(0.0, sin(fragCoord.y * 0.1 + uTime * 5.0));
    float atomo = step(0.09, ruidoAtomico(fragCoord.xy + vec2(uTime * 6.0, uTime * 2.5)));
    float efecto = mix(onda, atomo, step(0.5, uModo));

    float brillo = (color.r + color.g + color.b) * 0.33333;
    // Efecto Azul Eléctrico para Protanopia
    vec3 colorEfecto = vec3(0.0, 0.5 * brillo, 2.5 * brillo);

    fragColor = vec4(mix(color, colorEfecto, mascara * efecto), texColor.a);
}
