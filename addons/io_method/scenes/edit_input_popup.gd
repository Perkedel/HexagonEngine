tool
extends WindowDialog

export(Resource) var editing_input setget set_editing_input, get_editing_input

func _ready():
	if editing_input is InputSlot2D:
		$TextEdit.set_text( editing_input.activation_method )
		$TextEdit2.set_text( editing_input.deactivation_method )

func _on_TextEdit_text_changed( new_text:String ) -> void:
	if editing_input is InputSlot2D:
		editing_input.activation_method = new_text

func _on_TextEdit2_text_changed( new_text:String ) -> void:
	if editing_input is InputSlot2D:
		editing_input.deactivation_method = new_text

func get_editing_input() -> Node2D:
	return editing_input

func set_editing_input( value:Node2D ) -> void:
	editing_input = value

func _on_OkButton_pressed():
	hide()
	queue_free()