extends EditorInspectorPlugin

var InspectorToolButton = preload("inspector_button.gd")


func _can_handle(object) -> bool:
	return true


func _parse_property(
	object: Object, type: Variant.Type, 
	name: String, hint_type: PropertyHint, 
	hint_string: String, usage_flags, wide: bool):
	if name.begins_with("go_"):
		var s = str(name.split("go_")[1])
		s = s.replace("_", " ")
		s = "Press to %s" % s
		add_custom_control(
			InspectorToolButton.new(object, s))
		return true #Returning true removes the built-in editor for this property

	return false # else leave it
	
