tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("GCode", "Node", preload("GCode.gd"), preload("gcode.png"))

func _exit_tree():
	remove_custom_type("GCode")
