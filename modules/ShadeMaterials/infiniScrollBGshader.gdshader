shader_type canvas_item;
uniform vec2 scroll_speed;

// https://generalistprogrammer.com/godot/godot-infinite-scrolling-background-how-to/
// https://youtu.be/HnqBeqoTwJ8

void fragment(){
    vec2 shifteduv = UV;
    shifteduv += TIME * scroll_speed;
    vec4 color = texture(TEXTURE, shifteduv);
    COLOR = color;
}