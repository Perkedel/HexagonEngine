tool
extends EditorPlugin

var ed = get_editor_interface().get_editor_settings()

static func _get_ext_editor_path():
	# Check for external editor in Editor Settings
	var ext_editor_path = ""
	ext_editor = ed.get_setting("text_editor/external/exec_path")
	return ext_editor_path