tool
extends EditorPlugin

var binary_downloader : GDSQLiteBinaryDownloader

func _enter_tree():	
	var native_library : GDNativeLibrary = preload("res://addons/gd-sqlite/gd-sqlite.gdnlib")
	var library_path := native_library.get_current_library_path()
	
	var dir := Directory.new()
	
	if not dir.file_exists(library_path):
		push_warning('The addon "%s" will download a required binary' % get_plugin_name())
		
		call_deferred("instance_binary_downloader")

func _exit_tree():
	if is_instance_valid(binary_downloader):
		binary_downloader.queue_free()

func get_plugin_name() -> String:
	return 'gd-sqlite'

func get_plugin_icon() -> Object:
	var icon := Image.new()
	icon.load("res://icon.svg")
	
	return icon

func instance_binary_downloader() -> void:
	# Get the plugin config file
	var plugin_config_file := ConfigFile.new()
	if plugin_config_file.load("res://addons/gd-sqlite/plugin.cfg") != OK:
		push_error('The addon "%s"\'s plugin configuration file could not be loaded' % get_plugin_name())
		disable_plugin()
	
	# Make sure the 'version' is in the config file
	if not plugin_config_file.has_section_key('plugin', 'version'):
		push_error('The addon "%s"\'s plugin configuration file does not contain "version" information' % get_plugin_name())
		disable_plugin()
	
	var version := plugin_config_file.get_value('plugin', 'version') as String
	
	var binary_downloader_scene : PackedScene = preload("res://addons/gd-sqlite/scenes/binary_downloader.tscn")
	
	# Create, setup and add the binary downloader as child.
	# The downloader itself download the binary and remove itself from the scene.
	binary_downloader = binary_downloader_scene.instance() as GDSQLiteBinaryDownloader
	binary_downloader.version = version
	
	add_child(binary_downloader)