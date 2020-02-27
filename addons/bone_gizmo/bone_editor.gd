tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BoneEditor", "Spatial", preload("bone_editor_node.gd"), preload("bone_editor.png"))

func _exit_tree():
	remove_custom_type("BoneEditor")
