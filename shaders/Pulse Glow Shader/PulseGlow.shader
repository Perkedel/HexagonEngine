/*
Pulsating light shader for Godot 3.0+ (using GLES3)
Apply only to meshes with rounded corners!

Author:
	Fernando Cosentino
	
Usage:
	Albedo: base object color. Albedo's alpha channel works, 
	        but avoid using it for transparency
			
	Albedo Texture: texture for albedo
	
	Saturation: higher values cause a flat color in the middle with fast alpha edges
	            lower values cause blurred, softer gradient
	
	Pulse Rate: how many times the light pulses per second
	
	Pulse Intensity: how big the light becomes during pulses, 
	                 relative to original object size
	
	Opacity: alpha. Use this in animations to make objects fade in or out
*/

shader_type spatial;
render_mode blend_add, unshaded;
uniform vec4 albedo : hint_color = vec4(1.0,1.0,1.0,1.0);
uniform sampler2D albedo_texture : hint_albedo;
uniform float Saturation: hint_range(0.5,1) = 1.0;
uniform float PulseRate = 5.0;
uniform float PulseIntensity = 0.1;
uniform float Opacity : hint_range(0,1) = 1.0;

void vertex() {
	// Pulsating angular frequency: time * rate * 2pi
	float pulse_freq = TIME*PulseRate*6.2831853;
	// Pulsating amplitude: sine wave shifted and scaled to range 0.0 - 1.0
	float pulse_val = 0.5*(sin(pulse_freq)+1.0);
	// Sine^4 causes the wave to have strong fast peaks with larger intervals
	pulse_val = pow(pulse_val, 4);
	// Move the vertices along their own normals,
	// Using the generated wave and PulseIntensity
	VERTEX += NORMAL*(pulse_val*PulseIntensity);
}

void fragment() {
	// Color/texture is straight forward
	vec4 albedo_tex = texture(albedo_texture,UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	// How much is this normal aligned to camera:
	float normal_dot = dot(NORMAL, vec3(0,0,1));
	// Avoid negative numbers:
	normal_dot = max(normal_dot, 0.0);
	// Find the angle given normal Z as sin (in range 0.0 - pi/4)
	// And convert to range 0.0 - 1.0 (where pi/4 ~= 0.785398)
	float arc = asin(normal_dot*Saturation)/0.785398;
	// Power causes the values to smooth towards zero
	arc = pow(arc,10);
	// Starting value for alpha uses our angle, 
	// albedo alpha channel and the opacity parameter
	float alpha_value = arc*albedo.a*Opacity;
	// Opacity limits the maximum value
	alpha_value = min(Opacity, alpha_value);
	// Finally apply the alpha
	ALPHA = (alpha_value);
}
