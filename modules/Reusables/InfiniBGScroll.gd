tool
extends TextureRect
# https://generalistprogrammer.com/godot/godot-infinite-scrolling-background-how-to/
# https://youtu.be/HnqBeqoTwJ8

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name GeneralistInfiniBGScroll

#export(float) var scroll_speed_x = 0.4
export(Vector2) var scroll_speed = Vector2(0.4,0)
func _ready():
	self.material.set_shader_param("scroll_speed", scroll_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.material.set_shader_param("scroll_speed_x", scroll_speed.x)
	self.material.set_shader_param("scroll_speed", scroll_speed)
	pass
