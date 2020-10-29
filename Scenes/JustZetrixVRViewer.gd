extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var zetrixViewport:Viewport
var images

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Demo from 3D in 2D Godot official
func ReceiveZetrixViewport(getIt:Viewport):
	zetrixViewport = getIt
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	images = zetrixViewport.get_texture()
	$ZetrixTextureResult.texture = images
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zetrixViewport:
		#images = zetrixViewport.get_texture().get_data()
		#images.flip_y()
		#$ZetrixTextureResult.texture = images
		pass
	pass
