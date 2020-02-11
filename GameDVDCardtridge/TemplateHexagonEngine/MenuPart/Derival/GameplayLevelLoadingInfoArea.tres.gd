extends Control

export (Texture) var ThumbnailImage
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelPreviewNail.texture = ThumbnailImage
	pass # Replace with function body.

#Reb

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$LevelPreviewNail.texture = ThumbnailImage
	pass
