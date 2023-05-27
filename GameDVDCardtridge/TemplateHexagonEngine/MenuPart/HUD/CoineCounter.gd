extends HBoxContainer

@export (float) var CoineCountNumber
@export (Texture2D) var CoineIcon
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CoineCountLabel.text = String(CoineCountNumber)
	$CoineIcon.texture = CoineIcon
	pass
