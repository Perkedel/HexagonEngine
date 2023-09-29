@tool
extends EditorPlugin

var plugin


func _enter_tree():
	plugin = ControlEditorInspector.new()
	add_inspector_plugin(plugin)


func _exit_tree():
	if is_instance_valid(plugin):
		remove_inspector_plugin(plugin)
		plugin = null


class ControlEditorInspector extends EditorInspectorPlugin:
	
	const CursorShapeEditorProperty = preload("CursorShapeEditorProperty.gd")
	
	func _can_handle(object):
		return object is Control
	
	func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
		if name == "mouse_default_cursor_shape":
			add_property_editor(name, CursorShapeEditorProperty.new())
			return true
		return false
