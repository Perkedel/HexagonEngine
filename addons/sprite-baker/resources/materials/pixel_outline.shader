shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;

uniform vec4 outline_color: hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float depth_cutoff = 0.15;
uniform bool use_depth = false;
uniform bool blend = false;
uniform float px_x = 0.0312;
uniform float px_y = 0.0312;


void vertex() {
	POSITION = vec4(VERTEX.x, VERTEX.y, -1.0, 1.0);
}



void fragment() {
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	if (color.a < 0.5) {
		if (textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x - px_x, SCREEN_UV.y), 0.0).a > 0.5) {
			color = outline_color;
		} else if (textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + px_x, SCREEN_UV.y), 0.0).a > 0.5) {
			color = outline_color;
		} else if (textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x, SCREEN_UV.y - px_y), 0.0).a > 0.5) {
			color = outline_color;
		} else if (textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x, SCREEN_UV.y + px_y), 0.0).a > 0.5) {
			color = outline_color;
		} else {
			ALPHA = 0.0;
		}
	} else if (use_depth) {
		float scr_depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
  		vec3 ndc = vec3(SCREEN_UV, scr_depth) * 2.0 - 1.0;
		vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
		view.xyz /= view.w;
		float depth = -view.z;

		vec2 uv = vec2(SCREEN_UV.x - px_x, SCREEN_UV.y);
		scr_depth = texture(DEPTH_TEXTURE, uv).x;
		ndc = vec3(uv, scr_depth) * 2.0 - 1.0;
		view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
		view.xyz /= view.w;
		float depth_xm1 = -view.z;
		if (depth - depth_xm1 > depth_cutoff) {
			color = outline_color;
		} else {
			uv = vec2(SCREEN_UV.x + px_x, SCREEN_UV.y);
			scr_depth = texture(DEPTH_TEXTURE, uv).x;
			ndc = vec3(uv, scr_depth) * 2.0 - 1.0;
			view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
			view.xyz /= view.w;
			float depth_xp1 = -view.z;
			if (depth - depth_xp1 > depth_cutoff) {
				color = outline_color;
			} else {
				uv = vec2(SCREEN_UV.x, SCREEN_UV.y - px_y);
				scr_depth = texture(DEPTH_TEXTURE, uv).x;
				ndc = vec3(uv, scr_depth) * 2.0 - 1.0;
				view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
				view.xyz /= view.w;
				float depth_ym1 = -view.z;
				if (depth - depth_ym1 > depth_cutoff) {
					color = outline_color;
				} else {
					uv = vec2(SCREEN_UV.x, SCREEN_UV.y + px_y);
					scr_depth = texture(DEPTH_TEXTURE, uv).x;
					ndc = vec3(uv, scr_depth) * 2.0 - 1.0;
					view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
					view.xyz /= view.w;
					float depth_yp1 = -view.z;
					if (depth - depth_yp1 > depth_cutoff) {
						color = outline_color;
					}
				}
			}
		}
		
		
		
	}
	ALBEDO = color.rgb;
}
