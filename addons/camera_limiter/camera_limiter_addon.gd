tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("CameraLimiter", "Node", preload("focus_limiter.gd"), preload("node.svg"))
	add_custom_type("CameraLimitArea", "Area2D", preload("camera_limiting_area.gd"), preload("area_2d.svg"))

func _exit_tree():
	remove_custom_type("CameraLimiter")
	remove_custom_type("CameraLimitArea")
