tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Folder", "Node", preload("folder.gd"), preload("icon.svg"))


func _exit_tree():
	remove_custom_type("Folder")
