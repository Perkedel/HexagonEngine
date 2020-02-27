tool
extends EditorPlugin

const node_name = "Tello"

func _enter_tree():
    add_custom_type(node_name, "Node", preload("res://addons/TelloDroneNode/TelloDroneNode.gd"), preload("res://addons/TelloDroneNode/drone_icon.png"))

func _exit_tree():
    remove_custom_type(node_name)
