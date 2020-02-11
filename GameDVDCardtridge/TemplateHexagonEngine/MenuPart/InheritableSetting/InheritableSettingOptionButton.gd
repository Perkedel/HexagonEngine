extends HBoxContainer

export (String) var VariableName = "OptionButton"
export (int) var Selected = 0
enum OptionsAvailable {A, B, C, D}
export (OptionsAvailable) var OptionsInIt
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = VariableName
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Label.text = VariableName
	pass

func setSelected(value):
	$HBoxContainer/OptionButton.selected = value
	pass

func _on_OptionButton_item_focused(id):
	pass # Replace with function body.


func _on_OptionButton_item_selected(id):
	Selected = id
	pass # Replace with function body.
