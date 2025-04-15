shader_type canvas_item;

uniform sampler2D texture_sampler;
uniform vec2 sprite_size = vec2(64.0, 64.0); // Size of each frame in pixels
uniform int frames_per_row = 8;              // Number of frames per row in spritesheet
uniform vec4 debug_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
	// Called for every pixel the material is visible on.
}