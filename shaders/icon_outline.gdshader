shader_type canvas_item;

uniform float thickness = 30.0;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Alpha threshold. Anything above this counts as "solid"
uniform float alpha_cutoff = 0.2;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Binary mask
    float center = tex.a > alpha_cutoff ? 1.0 : 0.0;

    float edge = 0.0;

    for (float x = -thickness; x <= thickness; x++) {
        for (float y = -thickness; y <= thickness; y++) {
            vec2 offset = vec2(x, y);

            if (length(offset) > thickness) {
                continue;
            }

            float a = texture(TEXTURE, UV + offset * TEXTURE_PIXEL_SIZE).a;
            if (a > alpha_cutoff) {
                edge = 1.0;
            }
        }
    }

    vec4 color = tex;

    // Outline only where the current pixel is empty BUT neighbors contain solid sprite
    if (center == 0.0 && edge == 1.0) {
        color = outline_color;
    }

    COLOR = color;
}
