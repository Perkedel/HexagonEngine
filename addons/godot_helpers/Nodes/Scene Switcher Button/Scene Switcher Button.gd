extends Button

@export_file('*.tscn') var scene

func _ready():
	var err = connect("button_down", pressed)

func pressed():
	if scene:
		get_tree().change_scene_to_file(scene)

