extern Image gradient;
extern vec2 direction;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
  vec4 result = Texel(gradient, vec2(dot(direction, pixel_coords), 0));
  result.a = color.a;
  return result;
}
