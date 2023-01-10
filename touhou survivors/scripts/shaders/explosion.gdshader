shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;
uniform float offset;

void fragment(){
	float mask = (1.0 - smoothstep(size-0.1,size, length(UV - center))) * smoothstep(size-thickness-0.1,size-thickness, length(UV - center));
	
	vec2 disp = normalize(UV - center) * force * mask;
	
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV - disp);
	
//	COLOR.r = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x + offset, SCREEN_UV.y) - disp).r;
//	COLOR.g = texture(SCREEN_TEXTURE,SCREEN_UV - disp).g;
//	COLOR.b = texture(SCREEN_TEXTURE,vec2(SCREEN_UV.x - offset, SCREEN_UV.y) - disp).b;
}