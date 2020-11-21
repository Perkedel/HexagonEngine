// https://youtu.be/K9FBpJ2Ypb4
// https://github.com/GDQuest/godot-demos
// https://github.com/GDQuest/godot-demos
// https://github.com/GDQuest/godot-demos
// https://github.com/GDQuest/godot-demos/blob/master/2018/09-20-shaders/shaders/transition.shader
shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float smooth_size : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;

uniform vec4 color : hint_color;

void fragment()
{
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	COLOR = vec4(color.rgb, alpha);
}