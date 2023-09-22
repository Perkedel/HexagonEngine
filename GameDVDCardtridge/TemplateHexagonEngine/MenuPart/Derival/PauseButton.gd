extends Button

@export var IconOfIt:Texture2D
@export var TextOfIt:String = "Pause"
@export var UseTheme:bool = false
@export var TextureImage:Texture2D

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
