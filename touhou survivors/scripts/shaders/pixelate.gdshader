shader_type canvas_item;

uniform float time:hint_range(0.0, 1.57, 0.001) = 1.0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,96.233))) * 43758.5453);
}

void fragment()
{
	vec2 texture_resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	vec2 within_texture_pixel=floor(UV * texture_resolution);
	vec4 color= texture(TEXTURE,UV);
	
	if(sin(time) > rand(within_texture_pixel))
		COLOR = color;
	else
		COLOR = vec4(0.0,0.0,0.0,0.0);
}