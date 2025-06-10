shader_type canvas_item;

uniform float lod : hint_range(0.0, 10.0) = 2.5;
uniform float mix_percentage : hint_range(0.0, 1.0) = 0.25;
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 texture_color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	texture_color = mix(texture_color, color, mix_percentage);
	COLOR = texture_color;
}
