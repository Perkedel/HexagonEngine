class_name ScrollingTextureRect
extends TextureRect

# Scroll velocity:
# Velocity at which the texture scrolls. In pixels/second.
export var scroll_velocity: Vector2 = Vector2.ZERO
# Scrolling:
# Weather or not the texture scrolls.
export var scrolling: bool = true

# Local variable to keep track of the offset of the texture.
var progress: Vector2 = Vector2.ZERO



func _process(delta):
	
	if texture == null or !scrolling: return # Exit.
	
	
	var texture_size = texture.get_size()
	
	# Add movement.
	rect_position += scroll_velocity * delta
	progress += scroll_velocity * delta
	
	# Check if we moved over the size of a tile.
	while abs(progress.x) >= texture_size.x:
		progress.x -= texture_size.x * sign(scroll_velocity.x)
		rect_position.x -= texture_size.x * sign(scroll_velocity.x)
	
	while abs(progress.y) >= texture_size.y:
		progress.y -= texture_size.y * sign(scroll_velocity.y)
		rect_position.y -= texture_size.y * sign(scroll_velocity.y)
