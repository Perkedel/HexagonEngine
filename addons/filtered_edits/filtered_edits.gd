@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type(
		"FilteredLineEdit",
		"LineEdit",
		preload("res://addons/filtered_edits/filtered_line_edit/filtered_line_edit.gd"),
		preload("res://addons/filtered_edits/filtered_line_edit/LineEdit.svg")
	)
	add_custom_type(
		"FilteredTextEdit",
		"TextEdit",
		preload("res://addons/filtered_edits/filtered_text_edit/filtered_text_edit.gd"),
		preload("res://addons/filtered_edits/filtered_text_edit/TextEdit.svg")
	)


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("FilteredLineEdit")
	remove_custom_type("FilteredTextEdit")
	pass
