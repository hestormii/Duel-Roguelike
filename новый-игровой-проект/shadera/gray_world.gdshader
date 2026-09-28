shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(0.0, 32.0) = 0.0;
uniform float grayscale_amount : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 block = pixel_size * SCREEN_PIXEL_SIZE;
	vec2 snapped_uv = floor(SCREEN_UV / block) * block;
	vec3 color = textureLod(screen_texture, snapped_uv, 0.0).rgb;

	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	color = mix(color, vec3(gray), grayscale_amount);

	COLOR = vec4(color, 1.0);
}