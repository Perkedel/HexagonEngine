tool
extends FileDialog
class_name SelectScene

var newInstanceDocker
var OptionsDialog

func setup(_newInstanceDocker, _current_dir : String):
	self.newInstanceDocker = _newInstanceDocker
	current_dir = _current_dir

func _on_SelectScene_file_selected(path : String):
	var OptionsDialog = preload("res://addons/GhodBase.RunInstance/OptionsDialog.tscn").instance()
	OptionsDialog.SelectScene = self
	OptionsDialog.find_node("txtPath").text = current_dir
	OptionsDialog.current_path = current_path
	OptionsDialog.newInstanceDocker = newInstanceDocker
	get_tree().root.add_child(OptionsDialog)
	OptionsDialog.popup()
