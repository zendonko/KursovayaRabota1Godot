shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform sampler2D noise_texture : filter_linear, repeat_enable;
uniform float wave_strength = 0.2;
uniform float wave_scale = 0.1;
uniform float WaterOpacity = 1.0;
uniform int pixelation_level = 128;

void vertex() {
    vec2 global_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;

    float noise = texture(noise_texture, global_pos * wave_scale).r;
    float local_wave = sin(TIME * 1.2 + noise * 10.0) * wave_strength;

    VERTEX.y += local_wave;
}

void fragment() {
    // Пикселизация
    vec2 pixelUV = floor(UV * float(pixelation_level)) / float(pixelation_level);

    // Лёгкое дрожание цвета
    float flicker = sin(TIME * 2.0 + pixelUV.x * 20.0 + pixelUV.y * 10.0) * 0.1;

    // Более яркая болотная вода
    vec3 base_color = vec3(0.1, 0.2, 0.25); // тёмно-сине-зелёный
    vec3 final_color = base_color + flicker;

    // Усиливаем яркость
    final_color *= 1.8;

    ALBEDO = final_color;
    ALPHA = WaterOpacity;
    EMISSION = final_color * 0.2; // чуть-чуть светится, как радиоактивное моче болота
    METALLIC = 0.0;
    ROUGHNESS = 1.0;
}
