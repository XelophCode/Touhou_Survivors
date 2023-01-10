shader_type canvas_item;

uniform sampler2D noise;
uniform vec2 center;

void fragment() {
	vec2 displace = normalize(UV - center);
	vec4 noisepos = texture(noise,displace);
	vec2 distortedUV = SCREEN_UV + noisepos.r * 0.1;
	vec4 pixel_color = texture(TEXTURE,mix(distortedUV,UV,0.5));
	COLOR = pixel_color;
//	COLOR.a = -texture(TEXTURE,UV).a;
}
