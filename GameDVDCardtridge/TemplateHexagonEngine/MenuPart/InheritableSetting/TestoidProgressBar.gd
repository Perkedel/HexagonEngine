tool
extends HBoxContainer

export (String) var VariableName = "Testoid Progress"
export (float) var minimum = 0
export (float) var maximum = 100
export (float) var stepp = 0.01
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = VariableName
	$HBoxContainer/ProgressBar.min_value = minimum
	$HBoxContainer/ProgressBar.max_value = maximum
	$HBoxContainer/ProgressBar.step = stepp
	pass

func SetValue(value):
	$HBoxContainer/ProgressBar.value = value
	pass

func _on_ProgressBar_value_changed(value):
	pass # Replace with function body.
