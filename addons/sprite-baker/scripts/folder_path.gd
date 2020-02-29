tool
extends "line_edit.gd"

signal files_updated(file_names, base_dir)

# FBX only supported for v3.2 or newer
const SUPPORTED_EXTENSIONS = ["dae", "glb", "obj", "fbx", "escn"]
const Tools: Script = preload("tools.gd")

var folder_path: String = "" setget set_folder_path, get_folder_path
var MARGIN: int


func _ready() -> void:
	var stbx: StyleBoxFlat = get_stylebox("normal")
	MARGIN = int(get_icon("clear").get_width() + stbx.content_margin_left + \
		stbx.content_margin_right)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		self.text = fit_text(folder_path)


func _text_entered(new_text: String) -> void:
	self.folder_path = new_text


func set_folder_path(new_path: String) -> void:
	if folder_path == new_path:
		return
	var dir: = Directory.new()
	if new_path != "" && dir.dir_exists(new_path):
		folder_path = new_path
		if not folder_path.ends_with("/"):
			folder_path += "/"
		var files: PoolStringArray = search_files(folder_path, true)
		emit_signal("files_updated", files, folder_path)
		hint_tooltip = folder_path
	self.text = fit_text(folder_path)


func get_folder_path() -> String:
	return folder_path


func search_files(dir_path: String, recursive: bool) -> PoolStringArray:
	var files: = PoolStringArray()
	var dir: = Directory.new()
	assert(dir.open(dir_path) == OK)
	assert(dir.list_dir_begin(true, true) == OK)
	var file_name: String = dir.get_next()
	while (file_name != ""):
		if dir.current_is_dir():
			if recursive:
				files.append_array(search_files(dir_path + file_name + "/", false))
		elif is_3d_model(file_name):
			files.append(dir_path + file_name)
		file_name = dir.get_next()
	return files


func is_3d_model(file_name: String) -> bool:
	var file_ext: String = file_name.get_extension()
	for ext in SUPPORTED_EXTENSIONS:
		if file_ext == ext:
			return true
	return false


func fit_text(text: String) -> String:
	return Tools.fit_text(text, int(self.rect_size.x - MARGIN), get_font("font"))
