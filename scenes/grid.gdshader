shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float cell_size = 16.0;
uniform float line_width = 1.0;

void fragment() {
    vec2 pixel_pos = FRAGCOORD.xy;
    float mod_x = mod(pixel_pos.x, cell_size);
    float mod_y = mod(pixel_pos.y, cell_size);
    COLOR = mod_x < line_width || mod_y < line_width ? line_color : vec4(0.0);
}
