tool
extends EditorPlugin

const integerLineEditType = "IntegerLineEdit"

func _enter_tree():
	add_custom_type(integerLineEditType, "LineEdit", preload("integerLineEdit.gd"), preload("LineEdit3.png"))


func _exit_tree():
	remove_custom_type(integerLineEditType)
