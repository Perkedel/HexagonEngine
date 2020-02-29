tool
extends EditorPlugin

"""
	Plugin to convert a 3D model into a sprite sheet.
	When enabled, the plugin can be found under Project > Tools > SpriteBaker

	TODO:
		Better docs
"""

var dialog: AcceptDialog

func _enter_tree() -> void:
	add_tool_menu_item("SpriteBaker", self, "_on_tool_menu_pressed")
	get_dialog()


func _exit_tree() -> void:
	remove_tool_menu_item("SpriteBaker")
	if dialog:
		remove_control_from_container(CONTAINER_TOOLBAR, dialog)
		dialog.free()


func get_dialog() -> void:
	dialog = load("res://addons/sprite-baker/scenes/SpriteBakerDialog.tscn").instance()
	add_control_to_container(CONTAINER_TOOLBAR, dialog)


func _on_tool_menu_pressed(_ud) -> void:
	if !is_inside_tree():
		return
	if not dialog:
		get_dialog()
	dialog.popup_centered_ratio(0.85)
