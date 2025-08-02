shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // grid line color
uniform float cell_size = 16.0; // size of each cell in pixels
uniform float line_width = 1.0; // line width in pixels

void fragment() {
    vec2 pixel_pos = FRAGCOORD.xy;

    // Get local position inside a cell
    float mod_x = mod(pixel_pos.x, cell_size);
    float mod_y = mod(pixel_pos.y, cell_size);

    // If near the edge of a cell, draw the line
    if (mod_x < line_width || mod_y < line_width) {
        COLOR = line_color;
    } else {
        COLOR = vec4(0.0); // transparent or background color
    }
}
