shader_type spatial;

uniform vec4 grass_change_color : source_color = vec4(1.,1.,1.,1.);

uniform sampler2D grass_texture;
uniform sampler2D sand_texture;
uniform float height_scale : hint_range(-100.0, 100.0) = 1.0;
uniform float grass_scale : hint_range(-1.0, 400.0) = 1.0;
uniform float sand_scale : hint_range(-1.0, 400.0) = 1.0;
uniform float mixing : hint_range(1.0, 100.0) = 1.0;

varying vec3 pos;

void vertex() {
    // Vertex shader code
	pos = VERTEX;
}

void fragment() {
	
    // Get the grass color from the grass texture
    vec4 grass_color = texture(grass_texture, UV * grass_scale);
	//vec4 g = mix(grass_color, grass_change_color, 0.7);
	vec4 grass = grass_color * grass_change_color;
    
    // Get the sand color from the sand texture
    vec4 sand_color = texture(sand_texture, UV * sand_scale);
    
    // Get the height of the current point in the world
    float height = pos.y + height_scale;
    
    // Calculate the mix factor based on the height
    float mix_factor = clamp(height*mixing, 0.0, 1.0);
    
    // Blend the colors based on the mix factor
    vec4 final_color = mix(sand_color, grass, mix_factor);
    
    // Output the final color
    ALBEDO = final_color.rgb;

/*	if (pos.y >= 0.5) {
#		ALBEDO = vec3(0., 0.3, 0.);
#	}
#	else {
#		ALBEDO = vec3(0.5, 0.5, 0.);
#	}
*/	
}