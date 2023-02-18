shader_type canvas_item;

uniform sampler2D dissolve_texture;
uniform float dissolve_value : hint_range(0.0,1.0);
uniform float flash_modifier : hint_range(0.0,1.0);
uniform float opacity : hint_range(0.0,1.0);

void fragment(){
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(dissolve_texture, UV);
    main_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
	main_texture.a *= opacity;
	main_texture.rgb = mix(main_texture.rgb,vec3(1),flash_modifier);
    COLOR = main_texture;
}