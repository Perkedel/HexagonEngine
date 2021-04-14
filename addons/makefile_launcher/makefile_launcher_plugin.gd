tool
extends EditorPlugin

var make_ui

func _enter_tree():
	make_ui = preload("make_ui.tscn").instance()
	add_control_to_bottom_panel(make_ui, "Make")

func _exit_tree():
	remove_control_from_bottom_panel(make_ui)
	make_ui = null
