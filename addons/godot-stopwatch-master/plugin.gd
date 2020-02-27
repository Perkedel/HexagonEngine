tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Stopwatch", "Node", preload("scripts/stopwatch.gd"), preload("icons/icon.svg"))

func _exit_tree():
	remove_custom_type("Stopwatch")