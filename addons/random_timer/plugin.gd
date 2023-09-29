@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("RandomTimer", "Timer", preload("res://addons/random_timer/random_timer.gd"), preload("res://addons/random_timer/icon.svg"))

func _exit_tree() -> void:
	remove_custom_type("RandomTimer")
