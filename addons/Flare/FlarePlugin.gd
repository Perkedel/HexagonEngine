tool
extends EditorPlugin

func _enter_tree():
	add_custom_type(
		"FlareEmitter", "Spatial",
		preload("FlareLightGeneric.gd"),
		preload("Flare_ICON.png")
	)

func _exit_tree():
	remove_custom_type("FlareEmitter")