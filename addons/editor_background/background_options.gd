@tool
class_name EditorBackgroundPluginOptions
extends Window

@onready var background_transparency_spin_box = $VBoxContainer/background_transparency_option/SpinBox
@onready var editor_transparency_spin_box = $VBoxContainer/editor_transparency_option/SpinBox
@onready var background_z_index_spin_box = $VBoxContainer/background_z_index_option/SpinBox
@onready var random_time_change_interval_spin_box = $VBoxContainer/random_time_change_interval_option/SpinBox
@onready var set_background_button = $VBoxContainer/set_background
@onready var randomize_button = $VBoxContainer/randomize
@onready var set_background_folder_button = $VBoxContainer/set_background_folder
@onready var random_enabled_check_box = $VBoxContainer/random_enabled
@onready var random_time_change_enabled_check_box = $VBoxContainer/random_time_change_enabled
@onready var background_path_label = $VBoxContainer/background_path
@onready var background_folder_label = $VBoxContainer/background_folder
@onready var background_stretch_button = $VBoxContainer/background_stretch_option/OptionButton
@onready var background_filter_button = $VBoxContainer/background_filter_option/OptionButton

var main_plugin_script: EditorBackgroundPlugin

func _ready() -> void:
	close_requested.connect(func():
		queue_free()
	)
	
	main_plugin_script.background_folder_changed.connect(func(val):
		background_folder_label.text = 'Background Folder: %s' % [val]
	)
	background_folder_label.text = 'Background Folder: %s' % [main_plugin_script.background_folder] 
	
	main_plugin_script.background_z_index_changed.connect(func(val):
		if background_z_index_spin_box.value == val:
			return
		background_z_index_spin_box.value = val
	)
	background_z_index_spin_box.value = main_plugin_script.background_z_index
	
	main_plugin_script.background_transparency_changed.connect(func(val):
		if background_transparency_spin_box.value == val:
			return
		background_transparency_spin_box.value = val
	)
	background_transparency_spin_box.value = main_plugin_script.background_transparency
	
	main_plugin_script.editor_transparency_changed.connect(func(val):
		if editor_transparency_spin_box.value == val:
			return
		editor_transparency_spin_box.value = val
	)
	editor_transparency_spin_box.value = main_plugin_script.editor_transparency
	
	main_plugin_script.random_enabled_changed.connect(func(val):
		if random_enabled_check_box.button_pressed == val:
			return
		random_enabled_check_box.button_pressed = val
	)
	random_enabled_check_box.button_pressed = main_plugin_script.random_enabled
	
	main_plugin_script.background_path_changed.connect(func(val):
		background_path_label.text = 'Background Path: %s' % [val]
	)
	background_path_label.text = 'Background Path: %s' % [main_plugin_script.background_path]
	
	main_plugin_script.random_time_change_enabled_changed.connect(func(val):
		if random_time_change_enabled_check_box.button_pressed == val:
			return
		random_time_change_enabled_check_box.button_pressed = val
	)
	random_time_change_enabled_check_box.button_pressed = main_plugin_script.random_time_change_enabled
	
	main_plugin_script.random_time_change_interval_changed.connect(func(val):
		if random_time_change_interval_spin_box.value == val:
			return
		random_time_change_interval_spin_box.value = val
	)
	random_time_change_interval_spin_box.value = main_plugin_script.random_time_change_interval
	
	main_plugin_script.background_stretch_mode_changed.connect(func(val):
		if background_stretch_button.selected == val:
			return
		background_stretch_button.selected = background_stretch_enum_to_button_index(val)
	)
	background_stretch_button.selected = main_plugin_script.background_stretch_mode
	
	main_plugin_script.background_filter_mode_changed.connect(func(val):
		val = clamp(val-1, 0, INF)
		if background_filter_button.selected == val:
			return
		background_filter_button.selected = background_filter_enum_to_button_index(val)
	)
	background_filter_button.selected = clamp(main_plugin_script.background_filter_mode-1, 0, INF) 
	
	background_z_index_spin_box.value_changed.connect(func(val):
		main_plugin_script.background_z_index = val
	)
	
	background_transparency_spin_box.value_changed.connect(func(val):
		main_plugin_script.background_transparency = val
	)
	
	editor_transparency_spin_box.value_changed.connect(func(val):
		main_plugin_script.editor_transparency = val
	)
	
	random_time_change_interval_spin_box.value_changed.connect(func(val):
		main_plugin_script.random_time_change_interval = val
	)
	
	randomize_button.pressed.connect(func():
		main_plugin_script.update_background()
	)
	
	set_background_button.pressed.connect(func():
		var file_dialog = EditorFileDialog.new()
		file_dialog.size = Vector2(800, 500)
		file_dialog.file_selected.connect(func(path):
			main_plugin_script.background_path = path
		)
		file_dialog.close_requested.connect(func():
			file_dialog.queue_free()
		)
		file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
		file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
		file_dialog.filters = main_plugin_script.allowed_extensions_filter
		add_child(file_dialog)
		file_dialog.popup_centered()
	)
	
	set_background_folder_button.pressed.connect(func():
		var file_dialog = EditorFileDialog.new()
		file_dialog.size = Vector2(800, 500)
		file_dialog.dir_selected.connect(func(path):
			main_plugin_script.background_folder = path
		)
		file_dialog.close_requested.connect(func():
			file_dialog.queue_free()
		)
		file_dialog.access = EditorFileDialog.ACCESS_FILESYSTEM
		file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_DIR
		file_dialog.filters = main_plugin_script.allowed_extensions_filter
		add_child(file_dialog)
		file_dialog.popup_centered()
	)
	
	random_enabled_check_box.toggled.connect(func(button_pressed):
		main_plugin_script.random_enabled = button_pressed
	)
	
	random_time_change_enabled_check_box.toggled.connect(func(button_pressed):
		main_plugin_script.random_time_change_enabled = button_pressed
	)
	
	background_stretch_button.item_selected.connect(func(index):
		var enum_value = background_stretch_button_to_enum(index)
		main_plugin_script.background_stretch_mode = enum_value
	)
	
	background_filter_button.item_selected.connect(func(index):
		var enum_value = background_filter_button_to_enum(index)
		main_plugin_script.background_filter_mode = enum_value
	)

func background_filter_button_to_enum(index):
	var button_name = background_filter_button.get_item_text(index)
	var new_value = TextureRect.TEXTURE_FILTER_NEAREST
	match button_name:
		'Nearest':
			new_value = TextureRect.TEXTURE_FILTER_NEAREST
		'Linear':
			new_value = TextureRect.TEXTURE_FILTER_LINEAR
		'Nearest Mipmap':
			new_value = TextureRect.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		'Linear Mipmap':
			new_value = TextureRect.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		'Nearest Mipmap Anisotropic':
			new_value = TextureRect.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC
		'Linear Mipmap Anisotropic':
			new_value = TextureRect.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	return new_value

func background_filter_enum_to_button_index(enum_value):
	var new_value = 0
	match enum_value:
		TextureRect.TEXTURE_FILTER_NEAREST:
			new_value = 0
		TextureRect.TEXTURE_FILTER_LINEAR:
			new_value = 1
		TextureRect.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS:
			new_value = 2
		TextureRect.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS:
			new_value = 3
		TextureRect.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC:
			new_value = 4
		TextureRect.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC:
			new_value = 5
	return new_value

func background_stretch_button_to_enum(index):
	var button_name = background_stretch_button.get_item_text(index)
	var new_value = TextureRect.STRETCH_SCALE
	match button_name:
		'Stretch':
			new_value = TextureRect.STRETCH_SCALE
		'Tile':
			new_value = TextureRect.STRETCH_TILE
		'Keep':
			new_value = TextureRect.STRETCH_KEEP
		'Keep Centered':
			new_value = TextureRect.STRETCH_KEEP_CENTERED
		'Keep Aspect':
			new_value = TextureRect.STRETCH_KEEP_ASPECT
		'Keep Aspect Centered':
			new_value = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		'Keep Aspect Covered':
			new_value = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	return new_value

func background_stretch_enum_to_button_index(enum_value):
	var new_value = 0
	match enum_value:
		TextureRect.STRETCH_SCALE:
			new_value = 0
		TextureRect.STRETCH_TILE:
			new_value = 1
		TextureRect.STRETCH_KEEP:
			new_value = 2
		TextureRect.STRETCH_KEEP_CENTERED:
			new_value = 3
		TextureRect.STRETCH_KEEP_ASPECT:
			new_value = 4
		TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
			new_value = 5
		TextureRect.STRETCH_KEEP_ASPECT_COVERED:
			new_value = 6
	return new_value
