shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 6.0) = 2.0;
uniform float contrast : hint_range(0.5, 3.0) = 1.7;
uniform float brightness : hint_range(-0.5, 0.5) = 0.0;
uniform float black_point : hint_range(0.0, 0.5) = 0.1;
uniform float white_point : hint_range(0.5, 1.0) = 0.85;
uniform float grain_amount : hint_range(0.0, 0.2) = 0.05;

float noise_hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 block = pixel_size * SCREEN_PIXEL_SIZE;
	vec2 uv = (floor(SCREEN_UV / block) + 0.5) * block;
	vec3 col = textureLod(screen_texture, uv, 0.0).rgb;

	float g = dot(col, vec3(0.299, 0.587, 0.114));
	g = (g - 0.5) * contrast + 0.5 + brightness;
	g = smoothstep(black_point, white_point, g);
	g += (noise_hash(uv + mod(TIME, 10.0)) - 0.5) * grain_amount;

	COLOR = vec4(vec3(g), 1.0);
}