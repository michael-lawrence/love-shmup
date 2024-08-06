extern float shake;
extern vec2 screenSize;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 offset = vec2(
        sin(shake * 10.0 + screen_coords.y * 0.01) * 2.0,
        cos(shake * 10.0 + screen_coords.x * 0.01) * 2.0
    );

    vec2 newCoords = (screen_coords + offset) / screenSize;
    return Texel(texture, newCoords) * color;
}