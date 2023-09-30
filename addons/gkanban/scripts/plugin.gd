@tool
extends EditorPlugin

var plugin_interface = preload("res://addons/gkanban/components/PluginInterface.tscn").instantiate()

func _enter_tree():
	get_editor_interface().get_editor_main_screen().add_child(plugin_interface)
	_make_visible(false)


func _exit_tree():
	if plugin_interface:
		plugin_interface.queue_free()
		
func _has_main_screen()->bool:
	return true
	
func _get_plugin_name()-> String:
	return "G-Kanban"
	
func _get_plugin_icon():
	return preload("res://addons/gkanban/assets/icons/svg/gkanban_icon.svg")
	
func _make_visible(visible:bool)->void:
	if plugin_interface:
		plugin_interface.visible = visible
