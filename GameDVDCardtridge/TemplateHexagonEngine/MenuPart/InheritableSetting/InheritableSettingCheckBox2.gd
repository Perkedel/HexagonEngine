extends "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/InheritableSetting/InheritableSettingCheckBox.gd"

export (String) var Checkbox2Name = "Status 2"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if RadioMode:
		$HBoxContainer/CheckBox2.group = ButtonGrouper
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$HBoxContainer/CheckBox2.text = Checkbox2Name
	pass

signal CheckValue2(value)
func _on_CheckBox2_toggled(button_pressed):
	emit_signal("CheckValue2", button_pressed)
	pass # Replace with function body.
