extends HBoxContainer

export (String) var VariableName = "CheckBox"
export (String) var CheckBoxName = "Status"
export (bool) var RadioMode = false;
export (ButtonGroup) var ButtonGrouper
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = VariableName
	if RadioMode:
		$HBoxContainer/CheckBox.group = ButtonGrouper
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Label.text = VariableName
	$HBoxContainer/CheckBox.text = CheckBoxName
	pass

signal CheckValue(value)
func _on_CheckBox_toggled(button_pressed):
	emit_signal("CheckValue",button_pressed)
	pass # Replace with function body.
