@tool
class_name EditorBackgroundPlugin
extends EditorPlugin

var background_options: EditorBackgroundPluginOptions
var background_node: TextureRect
var base_control: Control
var viewport: Viewport
var editor_window: Window
var random_time_change_timer: Timer

var background_options_scene = preload('res://addons/editor_background/background_options.tscn')

func _enter_tree() -> void:
	allowed_extensions = get_extensions_from_filter(allowed_extensions_filter[0])
	base_control = get_editor_interface().get_base_control()
	viewport = get_viewport()
	editor_window = get_window()
	
	add_background_node()
	add_timer_node()

func _ready() -> void:
	viewport.size_changed.connect(func():
		background_node.size = viewport.size
	)
	background_node.size = viewport.size
	
	load_config()
	update_background()
	random_time_change_timer.timeout.connect(func():
		update_background()
	)
	
	add_tool_menu_item('Background Options...', func():
		if is_instance_valid(background_options): return
		background_options = background_options_scene.instantiate()
		background_options.main_plugin_script = self
		base_control.add_child(background_options)
		background_options.popup_centered()
	)

func _exit_tree() -> void: 
	save_config()
	editor_transparency = 1
#	editor_window_transparent = false
	remove_background_options()
	remove_background_node()
	remove_timer_node()
	remove_tool_menu_item('Background Options...')

var background_z_index: int = 0:
	set(val):
		background_z_index = val
		if not is_instance_valid(background_node):
			return
		background_node.z_index = val
		background_z_index_changed.emit(val)
signal background_z_index_changed(val)

var background_transparency: float = 0.2:
	set(val):
		background_transparency = val
		if not is_instance_valid(background_node):
			return
		background_node.modulate.a = val
		background_transparency_changed.emit(val)
signal background_transparency_changed(val)

var editor_transparency: float = 1:
	set(val):
		editor_transparency = val
		if not is_instance_valid(base_control):
			return
		base_control.modulate.a = val
		editor_transparency_changed.emit(val)
signal editor_transparency_changed(val)

#var editor_window_transparent: bool = false:
#	set(val):
#		editor_window_transparent = val
#		if not is_instance_valid(viewport):
#			return
#
#		viewport.transparent_bg = val
#		editor_window_transparent_changed.emit(val)
#signal editor_window_transparent_changed(val)
#
#var editor_clear_color: bool = false:
#	set(val):
#		editor_clear_color = val
#		if not is_instance_valid(viewport):
#			return
#
#		editor_clear_color_changed.emit(val)
#signal editor_clear_color_changed(val)

var random_time_change_interval: float = 50:
	set(val):
		random_time_change_interval = val
		if not is_instance_valid(random_time_change_timer): return
		random_time_change_timer.wait_time = val
		random_time_change_interval_changed.emit(val)
signal random_time_change_interval_changed(val)

var background_folder: String:
	set(val):
		background_folder = val
		background_folder_changed.emit(val)
signal background_folder_changed(val)

var background_stretch_mode: TextureRect.StretchMode = TextureRect.STRETCH_SCALE:
	set(val):
		background_stretch_mode = val
		if not is_instance_valid(background_node): return
		background_node.stretch_mode = val
		background_stretch_mode_changed.emit(val)
signal background_stretch_mode_changed(val)

var background_filter_mode: TextureRect.TextureFilter = TextureRect.TEXTURE_FILTER_NEAREST:
	set(val):
		background_filter_mode = val
		if not is_instance_valid(background_node): return
		background_node.texture_filter = val
		background_filter_mode_changed.emit(val)
signal background_filter_mode_changed(val)

var background_path: String:
	set(val):
		background_path = val
		update_background()
		background_path_changed.emit(val)
signal background_path_changed(val)

var random_enabled: bool:
	set(val):
		random_enabled = val
		random_enabled_changed.emit(val)
signal random_enabled_changed(val)

var random_time_change_enabled: bool:
	set(val):
		random_time_change_enabled = val
		if val:
			random_time_change_timer.start()
		else:
			random_time_change_timer.stop()

		random_time_change_enabled_changed.emit(val)
signal random_time_change_enabled_changed(val)

func load_config():
	var file = FileAccess.open('./addons/editor_background/user_config.json', FileAccess.READ)
	if not file: return
	
	var json_new = JSON.new()
	var json_parse_val = json_new.parse(file.get_as_text())
	if json_parse_val != OK:
		return
	var json_data: Dictionary = json_new.data

	background_path = json_data_get_fix(json_data, 'background_path', background_path)
	background_stretch_mode = json_data_get_fix(json_data, 'background_stretch_mode', background_stretch_mode)
	background_filter_mode = json_data_get_fix(json_data, 'background_filter_mode', background_filter_mode)
	background_folder = json_data_get_fix(json_data, 'background_folder', background_folder)
	random_enabled = json_data_get_fix(json_data, 'random_enabled', random_enabled)
	random_time_change_enabled = json_data_get_fix(json_data, 'random_time_change_enabled', random_time_change_enabled)
	random_time_change_interval = json_data_get_fix(json_data, 'random_time_change_interval', random_time_change_interval)
	background_z_index = json_data_get_fix(json_data, 'background_z_index', background_z_index)
	background_transparency = json_data_get_fix(json_data, 'background_transparency', background_transparency)
	editor_transparency = json_data_get_fix(json_data, 'editor_transparency', editor_transparency)

# prevents any value from actually being null when the json has a null value in it
func json_data_get_fix(json_data, string_value, default_value):
	return def_val(json_data.get(string_value, default_value), default_value)

func def_val(val, def_val):
	if val == null:
		return def_val
	return val 

func save_config():
	var file = FileAccess.open('./addons/editor_background/user_config.json', FileAccess.WRITE)
	if not file: return
	
	var json_new = JSON.new()
	var config = {
		'background_path': background_path,
		'background_stretch_mode': background_stretch_mode,
		'background_filter_mode': background_filter_mode,
		'background_folder': background_folder,
		'random_enabled': random_enabled,
		'random_time_change_enabled': random_time_change_enabled,
		'random_time_change_interval': random_time_change_interval,
		'background_z_index': background_z_index,
		'background_transparency': background_transparency,
		'editor_transparency': editor_transparency,
	}

	var json_string_val = json_new.stringify(config)
	file.store_string(json_string_val)

func add_background_node():
	var new_texture_rect = TextureRect.new()
	new_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	new_texture_rect.z_index = 0
	new_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_texture_rect.name = 'EditorBackgroundPluginBackground'
	viewport.add_child(new_texture_rect)
	background_node = new_texture_rect

func remove_background_node():
	if not is_instance_valid(background_node): return
	background_node.queue_free()

func remove_background_options():
	if not is_instance_valid(background_options): return
	background_options.queue_free()

func add_timer_node():
	var new_timer = Timer.new()
	new_timer.name = 'EditorBackgroundPluginTimer'
	random_time_change_timer = new_timer
	viewport.add_child(new_timer)

func remove_timer_node():
	if not is_instance_valid(random_time_change_timer): return
	random_time_change_timer.queue_free()
	
func get_background_files():
	var dir_access = DirAccess.open(background_folder)
	if not dir_access: return
	
	var dir_files = filter_files_from_extension(dir_access.get_files(), allowed_extensions)
	
	var files = []
	for i in dir_files:
		files.append('%s/%s' % [background_folder, i])
	return files

var allowed_extensions_filter = ['*.bmp, *.dds, *.exr, *.hdr, *.jpg, *.jpeg, *.png, *.tga, *.svg, *.svgz, *.webp; Supported Images']
var allowed_extensions = []

func filter_files_from_extension(files_arr, ext_arr):
	var filtered = []
	var skip_extension = false
	for file in files_arr:
		if is_extension(file, ext_arr):
			filtered.append(file)
	return filtered

func is_extension(file, ext_arr):
	for ext in ext_arr:
			if file.split('.')[1] == ext:
				return true
	return false

func get_extensions_from_filter(filter_str: String):
	return filter_str.replace('*.','').split(';')[0].replace(' ','').split(',')

func get_background_from_path(path: String) -> ImageTexture:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file: return
	
	var image = Image.load_from_file(path)
	var texture = ImageTexture.create_from_image(image)
	return texture

func get_random_background():
	var background_files = get_background_files()
	var new_random_background_path = background_files.pick_random()
	return get_background_from_path(new_random_background_path)

func update_background():
	var new_background_texture: Texture
	if random_enabled:
		new_background_texture = get_random_background()
	else:
		new_background_texture = get_background_from_path(background_path)
	
	background_node.texture = new_background_texture
