extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var imager : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	imager = $CanvasLayer/Control/ViewportContainer/Viewport.get_texture()
	#imager = get_viewport().get_texture()
	
	$CanvasLayer/Control/TextureRect.texture = imager
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
