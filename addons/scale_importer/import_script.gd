tool extends EditorPlugin

var plugin

func _enter_tree():
	plugin=preload("import_plugin.gd").new()
	add_import_plugin(plugin)

func _exit_tree():
	remove_import_plugin(plugin)
	plugin=null