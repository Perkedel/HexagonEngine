extends "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/InheritableSetting/InheritableSettingCheckButton.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ForceValue2(value:bool):
	$HBoxContainer/CheckButton2.button_pressed = value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal Statemento(value2)
func _on_CheckButton2_toggled(button_pressed):
	emit_signal("Statemento", button_pressed)
	pass # Replace with function body.
