shader_type canvas_item;

/*
The water wave effect is achieved using sine waves. Two sine waves are used to create "irregularities" with the use if wave interference.

Notes on uniform variables:
	water_color: Tints the texture.
	surface_level: Distance of water surface from top of Water node. High number = Larger distance.
	sine_oscillations_#: Number of waves. Higher number = More waves.
	sine_amplitude_#: How high the waves reach. Higher number = Shorter waves.
	sine_speed_#: How fast the waves move. Higher number = Higher speed.
*/
uniform vec4 water_color : hint_color;
uniform float surface_level : hint_range(0.0, 1.0) = 0.05;
uniform float sine_oscillations_1 = 20.0;
uniform float sine_amplitude_1 = 80.0;
uniform float sine_speed_1 = 2.0;
uniform float sine_oscillations_2 = 20.0;
uniform float sine_amplitude_2 = 100.0;
uniform float sine_speed_2 = 1.0;

void fragment() {
	// Get color of background at pixel's screen coordinate
	vec4 pixel_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	// Tint pixel_color with water_color, and increase contrast
	pixel_color = mix(pixel_color, water_color, 1);
	pixel_color.rgb = mix(vec3(0.5), pixel_color.rgb, 1.5);
	
	float near_top = UV.y + (sin(UV.x * sine_oscillations_1 + TIME * sine_speed_1) / sine_amplitude_1) + (sin(UV.x * sine_oscillations_1 + TIME * sine_speed_2) / sine_amplitude_2);
	
	if (near_top < surface_level) {
		pixel_color.a = 0.0;
	}
	
	// Set final pixel_color to be drawn	
	COLOR = pixel_color;
}