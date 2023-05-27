extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rootViewport
#var img
@onready var imgTexture = ImageTexture.new()

# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
func ReceiveRootViewport(getIt:SubViewport):
	rootViewport = getIt
	
	# Demo of Screen Capture Godot official
#	yield(VisualServer, "frame_post_draw")
#	img = rootViewport.get_texture().get_data()
#	img.flip_y()
#	imgTexture.create_from_image(img)
#	$ScreenMesh.material_override.albedo_texture = imgTexture
	
	# Demo of 2d in 3d demo Godot official
	await get_tree().idle_frame
	await get_tree().idle_frame
	# https://godotengine.org/qa/23713/how-to-convert-image-to-texture
	$ScreenMesh.material_override.albedo_texture = rootViewport.get_texture()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
