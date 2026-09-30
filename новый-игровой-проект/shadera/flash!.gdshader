shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform float vignette_power : hint_range(0.5, 4.0) = 2.0;

void fragment() {
	vec2 centered = SCREEN_UV - vec2(0.5);
	float dist = length(centered) * 1.4;
	float falloff = 1.0 - clamp(pow(dist, vignette_power), 0.0, 1.0);
	COLOR = vec4(flash_color.rgb, intensity * falloff);
}