shader_type canvas_item;

uniform float texture_value : hint_range(0.0, 1.0, 0.01) = 0;
uniform float texture_alpha : hint_range(0.0, 1.0, 0.01) = 1;

void fragment() {
	vec4 main_texture = texture(TEXTURE,UV);
	vec3 black_value = vec3(0.0);
	main_texture.rgb = mix(black_value,main_texture.rgb,texture_value);
	main_texture.a = texture_alpha;
	COLOR = main_texture;
}
