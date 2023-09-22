@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("ControllerInputViewer","Node2D",preload("res://addons/ControllerInputViewer/ControllerViewerCaller.gd"),preload("res://addons/ControllerInputViewer/ControllerHud/Assets/NodeIcon.svg"))
	pass

func _exit_tree():
	remove_custom_type("ControllerInputViewer")
	pass
