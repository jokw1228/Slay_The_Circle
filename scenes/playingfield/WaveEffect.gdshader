shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV  - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float edge = smoothstep(size-0.1, size, length(scaledUV - center));
	float innerEdge = smoothstep(size-thickness-0.1, size-thickness, length(scaledUV - center));
	float mask = (1.0 - edge) * innerEdge;
	
	vec2 disp = normalize(scaledUV - center) * force * mask;
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	
	COLOR = color;
}