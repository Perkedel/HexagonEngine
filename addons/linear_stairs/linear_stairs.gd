tool
extends EditorPlugin


func _enter_tree():
	var script : Script = preload("nodes/csg_linear_stairs.gd")
	var icon : Texture = preload("icons/linear_stairs_icon.svg")
	
	add_custom_type("CSGLinearStairs", "CSGCombiner", script, icon)


func _exit_tree():
	remove_custom_type("CSGLinearStairs")
