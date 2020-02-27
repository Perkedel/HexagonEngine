tool
extends EditorPlugin

var dock = null
var ed = get_editor_interface().get_editor_settings()

func _enter_tree():
	# First load the dock scene and instance it:
	dock = preload("res://addons/snippets_plugin/snippets_dock.tscn").instance()
	# Add the loaded scene to the docks:
	add_control_to_dock( EditorPlugin.DOCK_SLOT_LEFT_BR, dock)
	# Note that LEFT_BR means the left of the editor, bottom-right dock
	get_ext_editor()

func get_ext_editor():
	# Check for external editor in Editor Settings
	var ext_editor = ed.get_setting("text_editor/external/exec_path")
	if not ext_editor == "":
		dock.ext_editor_path = ext_editor
	else:
		dock.ext_editor_path = ""


func _exit_tree():
	# Clean-up / Unload Interface
	# Remove the scene from the docks:
	remove_control_from_docks( dock ) # Remove the dock
	if(dock!=null):
		dock.free()
		dock = null

