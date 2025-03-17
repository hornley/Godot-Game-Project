shader_type canvas_item;

uniform float break_amount : hint_range(0.0, 1.0) = 0.5; // 0 = normal, 1 = fully broken
uniform float spread = 0.1; // Maximum movement distance
uniform float chunk_size = 8.0; // Size of each chunk (in pixels)
uniform float move_probability = 0.5; // Probability that a chunk moves

void fragment() {
    vec2 tex_size = vec2(textureSize(TEXTURE, 0)); // Texture size in pixels
    vec2 uv_size = vec2(1.0) / tex_size; // Size of one pixel in UV space
    vec2 center = vec2(0.5); // Center of the sprite in UV

    // Convert UV to pixel coordinates
    vec2 pixel_coord = UV * tex_size;

    // Compute the chunk's top-left coordinate
    vec2 chunk_coord = floor(pixel_coord / chunk_size) * chunk_size;

    // Convert back to UV space
    vec2 chunk_uv = chunk_coord / tex_size;

    // Generate a random factor per chunk (ensures chunks move together)
    float random_factor = fract(sin(dot(chunk_uv, vec2(12.9898, 78.233))) * 43758.5453);

    // Default new position is the same chunk
    vec2 new_chunk_uv = chunk_uv;

    // Move chunks outward if they are selected to move
    if (random_factor < move_probability) {
        vec2 direction = normalize(chunk_uv - center); // Outward movement direction

        // Move chunks in whole chunk steps (snap to chunk size)
        new_chunk_uv += round(direction * random_factor * spread * break_amount * tex_size) / tex_size;
    }

    // Sample the texture at the new chunk position
    COLOR = texture(TEXTURE, new_chunk_uv + (pixel_coord - chunk_coord) / tex_size);
}
