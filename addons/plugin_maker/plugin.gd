tool
extends EditorPlugin

var create_plugin_dialog = preload("res://addons/plugin_maker/create_plugin_dialog.tscn").instance()

func create_plugin(plugin_name : String, plugin_description : String):
	var plugin_code_name := plugin_name.replace(" ", "_").to_lower()
	var plugin_path := "addons".plus_file(plugin_code_name)
	var plugin_adds_node := plugin_name.ends_with("Node")
	var node_added := plugin_name.replace(" Node", "") if plugin_adds_node else ""
	var node_name := node_added.to_lower()
	var node_script_path := plugin_path.plus_file(node_name + ".gd")
	var node_icon_file_path := plugin_path.plus_file(node_name + "_icon.svg")
	var add_type_code := "add_custom_type(\"%s\", \"Node\", load(\"%s\"), load(\"%s\"))" % [node_added, node_script_path, node_icon_file_path]
	var remove_type_code := "remove_custom_type(\"%s\")" % [node_added]
	
	var addons : Directory = Directory.new()
	addons.make_dir_recursive(plugin_path)
	
	var plugin_script : File = File.new()
	plugin_script.open(plugin_path.plus_file("plugin.gd"), File.WRITE)
	plugin_script.store_string(
"""tool
extends EditorPlugin

func _enter_tree():
	%s


func _exit_tree():
	%s

""" % [add_type_code if plugin_adds_node else "pass", remove_type_code if plugin_adds_node else "pass"])
	plugin_script.close()
	
	var plugin_config = ConfigFile.new()
	plugin_config.set_value("plugin", "name", plugin_name)
	plugin_config.set_value("plugin", "description", plugin_description + (("\nAdds a %s node." % node_added) if plugin_adds_node else ""))
	plugin_config.set_value("plugin", "author", "Jummit")
	plugin_config.set_value("plugin", "version", "1.0")
	plugin_config.set_value("plugin", "script", "plugin.gd")
	plugin_config.save(plugin_path.plus_file("plugin.cfg"))
	
	if plugin_adds_node:
		var node_file : File = File.new()
		node_file.open(node_script_path, File.WRITE)
		node_file.store_string("extends Node\n")
		node_file.close()
		
		var node_icon_file : File = File.new()
		var default_node_icon_file : File = File.new()
		node_icon_file.open(node_icon_file_path, File.WRITE)
		default_node_icon_file.open("res://addons/plugin_maker/default_node_icon.svg", File.READ)
		node_icon_file.store_string(default_node_icon_file.get_as_text())
		node_icon_file.close()
	
	get_editor_interface().get_resource_filesystem().scan()
	get_editor_interface().get_resource_filesystem().scan_sources()
	yield(get_tree().create_timer(1), "timeout")
	get_editor_interface().set_plugin_enabled(plugin_code_name, true)


func _enter_tree():
	add_tool_menu_item("Create Plugin", self, "_on_CreatePlugin_clicked")
	get_editor_interface().get_base_control().add_child(create_plugin_dialog)
	create_plugin_dialog.connect("confirmed", self, "_on_CreatePluginDialog_confirmed")


func _exit_tree():
	remove_tool_menu_item("Create Plugin")
	create_plugin_dialog.queue_free()


func _on_CreatePlugin_clicked(ud):
	create_plugin_dialog.popup_centered()


func _on_CreatePluginDialog_confirmed():
	create_plugin(create_plugin_dialog.get_node("HBoxContainer2/PluginNameEdit").text, create_plugin_dialog.get_node("HBoxContainer2/PluginDescriptionEdit").text)
