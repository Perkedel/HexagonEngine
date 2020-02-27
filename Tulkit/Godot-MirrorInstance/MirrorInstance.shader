shader_type spatial;
render_mode unshaded;


uniform sampler2D refl_tx;

void fragment() {
	ALBEDO = texture(refl_tx, vec2(1.0 - SCREEN_UV.x, SCREEN_UV.y)).rgb;
}
