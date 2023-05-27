@tool
extends HBoxContainer

@export (String) var VariableName = "CheckButton"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = VariableName
	pass # Replace with function body.

func ForceValue(value: bool):
	$HBoxContainer/CheckButton.button_pressed = value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = VariableName
	pass

signal Statement(value1)
func _on_CheckButton_toggled(button_pressed):
	emit_signal("Statement", button_pressed)
	pass # Replace with function body.
