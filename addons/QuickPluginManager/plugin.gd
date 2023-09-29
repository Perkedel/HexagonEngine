#Written:
#Date: 01/26/2019
#Author: Markus Septer
#Contributors: David Boucher, update to Godot 4, 10/17/2022

#How to use:
#1)If you already have "addons" folder in "res://", jump to step (3)
#2)If you don't have "addons" folder in "res://" create it
#3)Drag and drop the folder this script is (should be named "QuickPluginMaker") in into "res://addons"

#Folder structure should look like this: "res://addons/QuickPluginManager"
#NB:if you wish to change name of this plugin through godot editor you also have to change var "PLUGIN_SELF_NAME" to same name

@tool
extends EditorPlugin

const PLUGIN_PATH = "res://addons"
const POPUP_BUTTON_TEXT = "Manage Plugins"
const MENU_BUTTON_TOOLTIP = "Quickly enable/disable plugins"
#if you change name of plugin from godot editor this variable also must changed to same
const PLUGIN_SELF_NAME = "QuickPluginManager"

var _plugin_menu_btn = MenuButton.new()
var _plugins_menu = _plugin_menu_btn.get_popup()

var _plugins_data = {}
var _menu_items_idx = 0


func _enter_tree():
	_plugin_menu_btn.text = POPUP_BUTTON_TEXT
	_plugin_menu_btn.tooltip_text = MENU_BUTTON_TOOLTIP
		
	_populate_menu()
	
	_plugins_menu.index_pressed.connect(_item_toggled.bind(_plugins_menu))
	_plugin_menu_btn.about_to_popup.connect(_menu_popup_about_to_show)
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)


func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)

	if _plugin_menu_btn:
		_plugin_menu_btn.queue_free()


func _item_toggled(item_index, menuObj):
	var is_item_checked = menuObj.is_item_checked(item_index)
	_plugins_menu.set_item_checked(item_index, not is_item_checked)

	for plugin_name in _plugins_data:
		var plugin_info = _plugins_data[plugin_name]
		
		if item_index == plugin_info.menu_item_index:
			var plugin_folder_name = plugin_info.plugin_folder
			get_editor_interface().set_plugin_enabled(plugin_folder_name, not is_item_checked)

func _refresh_plugins_menu_list():
	_plugins_menu.clear()
	_menu_items_idx = 0
	_plugins_data.clear()
	_populate_menu()

func _populate_menu():
	#Get list of addons directories
	var addons_list: Array = []
	addons_list = get_list_directories_name_at("res://addons/")
	#print list of addons name
#	for a in addons_list:
#		print(a)
	
	#Get files path of each addon .cfg
	if addons_list != null:
		for addon_name in addons_list:
			var addon_cfg_path: Array = []
			addon_cfg_path = get_list_path_of_files_with_ext("res://addons/"+addon_name+"/", ".cfg")
			if addon_cfg_path != null:
				#If more than one cfg file exist, only keep plugin.cfg
				if addon_cfg_path.size() > 1:
					var idx = 0
					for cfg in addon_cfg_path:
						if cfg.right(10) != "plugin.cfg":
							addon_cfg_path.remove_at(idx)
						idx += 1
			
				if addon_cfg_path != null and addon_cfg_path.size() > 0:
#					print(addon_cfg_path)
				
					#Add addon to _plugins_menu
					var conf = ConfigFile.new()
					conf.load(addon_cfg_path[0]) #take the first .cfg file found in each addon directory
					var plugin_name = str(conf.get_value("plugin", "name"))
					var plugin_info = { "plugin_folder":addon_name, "menu_item_index":_menu_items_idx }

					var isPluginEnabled = get_editor_interface().is_plugin_enabled(addon_name)

					if plugin_name != PLUGIN_SELF_NAME:
						_plugins_menu.add_check_item(plugin_name)
						_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
						_plugins_data[plugin_name] = plugin_info
						_menu_items_idx += 1
		
		#no need to increment "_menu_items_idx" as we already did it above
		#add plugin itself as last item to menu
		_plugins_menu.add_check_item(PLUGIN_SELF_NAME)
		_plugins_menu.set_item_checked(_menu_items_idx, get_editor_interface().is_plugin_enabled(PLUGIN_SELF_NAME))
		_plugins_menu.set_item_disabled(_menu_items_idx, true)
	else:
		print("An error occurred when trying to access the path.")

func _menu_popup_about_to_show():
	_refresh_plugins_menu_list()


func get_list_path_of_files_with_ext(path: String, ext: String):
	var path_array: Array = []
	for file in DirAccess.get_files_at(path):
		if file.ends_with(ext):
			path_array.append(path+file)
	return path_array

func get_list_directories_name_at(path: String):
	var path_array: Array = []
	for dir in DirAccess.get_directories_at(path):
		path_array.append(dir)
	return path_array
