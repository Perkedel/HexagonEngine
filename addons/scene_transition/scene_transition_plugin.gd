tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("scene_manager", "res://addons/scene_transition/scene_transition_manager.gd")

func _exit_tree():
	remove_autoload_singleton("scene_manager")
