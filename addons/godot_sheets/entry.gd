tool
extends EditorPlugin

var ConfigPopup = preload("./SheetsConfig.tscn")
var config_popup:Node

func _enter_tree():
	# Initialization of the plugin goes here
	config_popup = ConfigPopup.instance()

	config_popup.api.connect("sheet_loaded", self, "save_singleton")
	config_popup.enabled = true
	get_editor_interface().get_base_control().add_child(config_popup)
	add_tool_menu_item("Config Godot Sheets",self,"open_config")

func open_config(UD):
	var window = config_popup.get_node("WindowDialog") as WindowDialog
	if(window):
		window.popup_centered_ratio(0.3)

func _exit_tree():
	# Clean-up of the plugin goes here
	remove_tool_menu_item("Config Godot Sheets")
	if(config_popup):
		config_popup.queue_free()


func save_singleton(filename):
	var name = filename.get_basename().get_file()
	add_autoload_singleton(name,filename)
	config_popup.handle_log("Autoload Singleton Added \""+str(name)+"\" from \""+filename+"\"")
