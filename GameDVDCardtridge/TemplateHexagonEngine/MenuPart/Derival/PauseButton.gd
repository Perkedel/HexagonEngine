extends Button

export (Texture) var IconOfIt
export (String) var TextOfIt = "Pause"
export (bool) var UseTheme = false
export (Texture) var TextureImage

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if UseTheme:
		$TextureRect.show()
		pass
	if IconOfIt:
		$HBoxContainer/Icon.texture = IconOfIt
		pass
	$HBoxContainer/Label.text = TextOfIt
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
