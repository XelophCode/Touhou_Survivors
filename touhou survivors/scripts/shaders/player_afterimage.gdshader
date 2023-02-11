shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0, 0.001) = 1.0;

void fragment() {
	vec4 clean_texture = texture(TEXTURE,UV);
	vec4 main_texture = texture(TEXTURE,UV);
	main_texture.g = abs(sin(TIME * 1.1));
	main_texture.b = abs(sin(TIME * 1.8));
	main_texture.r = abs(sin(TIME * 1.3));
	main_texture.rgb = mix(clean_texture.rgb,main_texture.rgb,0.6);
	
	main_texture.a = alpha * clean_texture.a;
	COLOR = main_texture;
}
