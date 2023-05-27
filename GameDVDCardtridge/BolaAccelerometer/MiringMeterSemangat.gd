extends Panel

@export var Daya:float = 25
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$SemangatLevel/HBoxContainer/VBoxContainer/CenterContainer/GelembungSemangat.rect_position.x = Input.get_accelerometer().x
#	$SemangatLevel/HBoxContainer/VBoxContainer/CenterContainer/GelembungSemangat.rect_position.y = Input.get_accelerometer().y
	$SemangatLevel/HBoxContainer/VBoxContainer/CenterContainer/GelembungSemangat.set_position(Vector2(Input.get_accelerometer().x * -Daya, Input.get_accelerometer().y * Daya))
	pass
